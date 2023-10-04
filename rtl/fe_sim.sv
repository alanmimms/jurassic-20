// Simulate the front end functions we need to test the KL10-PV.

`include "kl10pv.svh"
`include "dte.svh"

typedef bit [0:7] tDRAMAddress;

`define STRINGIFY(S)	`"S`"

// Here `clk` is the `CLK 10/11 CLK H` from the CLK module PDF169.
module fe_sim(input bit clk,
	      input bit clk60,
	      inout 	 iEBUS ebus,
	      output 	 tEBUSdriver EBUSdriver,
	      input 	 mbc3_a_change_coming_a_l,
	      input 	 a_change_coming_in_l,
	      output bit crobar_e_h,
	      output bit con_cono_200000_h);

  string indent = "";
  int dumpFD;

  tCRAM cw;
  tCRAM cram136;
  tCRAM cram137;

  bit a_change_coming, a_change_coming_in;
  always_comb a_change_coming = !mbc3_a_change_coming_a_l;
  always_comb a_change_coming_in = !a_change_coming_in_l;

  bit didCRAMReadBack = 0;

  // The DRAM ("DISPATCH RAM" - not "DYNAMIC RAM") addressing
  // architecture in the KL10 is arse -- a bridge too far. Even the
  // microcode guys made fun of the choice as is evidenced by this
  // quip from the microcode listing:
  //
  //     The J field is the starting location of the microroutine to
  //     execute the instruction.  Note that the 40 and 20 bits must
  //     always be zero.  Also, even-odd pairs of DRAM J fields may
  //     differ only in the low order three bits.  (Someone thought he
  //     was being very clever when he designed the machine this way.
  //     It probably reduced our transfer cost by at least five
  //     dollars, after all, and the microcode pain that occurred
  //     later didn't cost anything, in theory.)
  //
  // Indeed, the intrepid microcoders bore the brunt of that
  // complexity.

  initial begin
    con_cono_200000_h = '0;
  end

  // From `images/ucode/convrt/convrt.txt`
  //
  // 3.0	FILE FORMATS
  //
  // 	THE PROGRAM FILES CONSIST OF BINARY DATA WHICH HAS BEEN
  // 	"ASCIIZED", THAT IS, MANIPULATED SUCH THAT 6 OR LESS BITS
  // 	OF THE BINARY DATA ARE REPRESENTED BY A 7-BIT CHARACTER
  // 	WHOSE VALUE RANGES FROM OCTAL 075 TO OCTAL 174.  THIS
  // 	PROCESS IS EMPLOYED TO AVOID THE PROBLEMS WHICH WOULD BE
  // 	ENCOUNTERED IF CERTIAN 7-BIT COMBINATIONS WERE ALLOWED
  // 	(E.G., OCTAL 003 WOULD BE INTERPRETED AS "CONTROL C").
  //
  // 	"ASCIIZED" DATA IS PRODUCED FROM THE SOURCE BINARY DATA AS
  // 	FOLLOWS:
  //
  // 	1.  DIVIDE THE BINARY DATA INTO 6-BIT FIELDS, STARTING WITH
  // 	    THE LEAST SIGNIFICANT 6 BITS.  DEPENDING ON THE NUMBER
  // 	    OF BITS IN THE SOURCE DATA, THE MOST SIGNIFICANT FIELD
  // 	    MAY BE COMPOSED OF FROM 1 TO 6 BITS.
  //
  // 	2.  CONVERT EACH FIELD INTO A 7-BIT CHARACTER USING THE
  // 	    FOLLOWING PROCEDURE:
  //
  // 	   2A.	IF THE FIELD HAS A VALUE LESS THAN OCTAL 75, ADD
  // 		OCTAL 100 (PRODUCING 7-BIT VALUES RANGING FROM
  // 		OCTAL 100 TO OCTAL 174).
  //
  // 	   2B.	IF THE FIELD HAS VALUES OCTAL 75, 76, OR 77 USE
  // 		THE FIELD DIRECTLY (PRODUCING 7-BIT VALUES 075,
  // 		076, OR 077).
  //
  // 	EXAMPLE:
  //
  // 	A 16 BIT WORD CONTAINING OCTAL 176076 IS DIVIDED INTO 3 FIELDS
  // 	(ONE 4-BIT AND TWO 6-BIT):
  //
  // 		17, 60, 76
  //
  // 	THE FIELDS ARE CONVERTED INTO 7-BIT CHARACTERS:
  //
  // 		117, 160, 076
  //
  // 	WHICH ARE THE ASCII CODES FOR THE GRAPHICS:
  //
  // 		O, LOWER CASE P, >

  ////////////////////////////////////////////////////////////////

  // 6.0	KL10 MICRO CODE FILE FORMATS

  // 	THE KL10 MICRO CODE FILE CONSISTS OF TWO DIFFERENT TYPES
  // 	OF DATA.
  //
  //	THE CONTROL RAM CONSISTS OF 80 BITS PLUS A 5 BIT SPECIAL FIELD
  //	[I say this is actually six bits: {CALL,DISP[0:4]}] PER
  //	CONTROL RAM LOCATION.  THIS THEN REQUIRES SIX 16 BIT WORDS TO
  //	REPRESENT THE CONTROL RAM DATA.  THE LOAD FILE IS ARRANGED SO
  //	AS [to] FACILITATE LOADING OF THE C-RAM WITH THE "WCRAM"
  //	ROUTINE.
  //
  // 	THE DISPATCH RAM CONSISTS OF PAIRS OF LOCATIONS.  THIS
  // 	THEN REQUIRES THREE 16 BIT WORDS PER PAIR OF D-RAM LOCATIONS.
  // 	THIS FILE IS ARRANGED TO FACILITATE LOADING OF THE D-RAM 
  // 	WITH THE "WDRAM" ROUTINE.
  //
  // 	BOTH THE C-RAM AND D-RAM DATA ARE COMBINED INTO A SINGLE
  // 	LOAD FILE TO FACILITATE HANDLING AND TO KEEP THE ASSOCIATED
  // 	VERSIONS TOGETHER.
  //
  // 	THE MICRO CODE LOAD FILE ALSO CONTAINS A C-RAM ZERO LINE
  // 	USED TO ZERO THE CONTROL RAM BEFORE LOADING ANY DATA INTO
  // 	IT.  THE C-RAM IS ZEROED FROM LOCATION ZERO UP TO THE HIGHEST
  // 	USED C-RAM LOCATION.
  //
  // 	IF THE MICRO-CODE DOES NOT CONTAIN ANY DATA IN C-RAM LOCATION
  // 	0, THE "Z" BLOCK IS NOT DONE WHICH PREVENTS C-RAM ZEROING AND
  // 	ALLOWS FOR MICRO-CODE OVERLAYS TO BE GENERATED.
  //
  // 	EXAMPLE FILE:
  //
  // 	Z WC,ADR,COUNT,CKS			[added COUNT]
  // 	C WC,ADR,DATA,DATA,...,CKSUM
  // 	C  "
  // 	C  "
  // 	C ,,
  // 	D WC,ADR,DATA,DATA,...,CKSUM
  // 	D  "
  // 	D  "
  // 	D ,,
  //
  // 	CONTROL RAM FORMAT
  // 	------------------
  //
  // 	Z WC,ADR,COUNT,CKSUM
  //
  // 	Z	;C-RAM ZERO
  // 		;SPACE, ASCIIZED FORMAT
  // 	WC	;WORD COUNT = 1
  // 	ADR	;ZERO START ADDRESS = 0
  // 	COUNT	;ZERO COUNT, DERIVED FROM HIGHEST USED ADDRESS
  //
  // 	C WC,ADR,64-79,48-63,32-47,16-31,00-15,0-4,.....,CKSUM
  //
  // 	C	;C-RAM FILE IDENTIFIER
  // 		;SPACE, ASCIIZED FILE TYPE
  // 	WC	;WORD COUNT, C-RAM WORD COUNT TIMES 6, 6 PDP-11
  // 		; WORDS PER C-RAM WORD
  // 	ADR	;C-RAM ADDRESS FOR THIS LOAD FILE LINE
  // 	64-79	;C-RAM BITS AS SPECIFIED UNDER "WCRAM"
  // 	48-63	;C-RAM BITS AS SPECIFIED UNDER "WCRAM"
  // 	32-47	;C-RAM BITS AS SPECIFIED UNDER "WCRAM"
  // 	16-31	;C-RAM BITS AS SPECIFIED UNDER "WCRAM"
  // 	00-15	;C-RAM BITS AS SPECIFIED UNDER "WCRAM"
  // 	80-84	;C-RAM BITS AS SPECIFIED UNDER "WCRAM"
  // 	CKSUM	;16 BIT NEGATED CHECKSUM OF WC, ADR & DATA
  //
  // 	C ,,
  //
  // 	C	;C-RAM FILE IDENTIFIER
  // 		;SPACE, ASCIIZED FILE FORMAT
  // 	,	;WC = 0, END OF FILE
  // 	,	;ADR = 0, NO START ADDRESS
  //
  // 	A C-RAM LOAD FILE LINE MAY CONTAIN UP TO 5 C-RAM LOCATIONS.
  // 	THE FILE LINE CHECKSUM IS THE 16 BIT NEGATED CHECKSUM OF
  // 	THE WORD COUNT, THE LOAD ADDRESS AND THE C-RAM DATA
  // 	REPRESENTED IN 16 BIT FORMAT.
  //
  // 6.0	KL10 MICRO CODE FILE FORMATS (CON'T)
  //
  // 	D-RAM FORMAT
  // 	------------
  //
  // 	D WC,ADR,EVEN,ODD,COMMON,.......,CKSUM
  //
  // 	D	;D-RAM FILE IDENTIFIER
  // 		;SPACE, ASCIIZED FILE TYPE
  // 	WC	;WORD COUNT, D-RAM LOCATION PAIRS TIMES 3, 3 PDP-11
  // 		; 16 BIT WORDS PER PAIR OF LOCATIONS.
  // 	EVEN	;D-RAM EVEN BITS AS SPECIFIED UNDER "WDRAM"
  // 	ODD	;D-RAM ODD BITS AS SPECIFIED UNDER "WDRAM"
  // 	COMMON	;D-RAM COMMON BITS AS SPECIFIED UNDER "WDRAM"
  // 	CKSUM	;16 BIT NEGATED CHECKSUM OF WC, ADR & DATA
  //
  // 	D ,,
  //
  // 	D	;D-RAM FILE IDENTIFIER
  // 		;SPACE, ASCIIZED FILE FORMAT
  // 	,	;WC = 0, END OF FILE
  // 	,	;ADR = 0, NO START ADDRESS
  //
  // 	A D-RAM LOAD FILE LINE MAY CONSIST OF UP TO 10
  // 	PAIRS OF D-RAM LOCATIONS.
  // 	THE FILE LINE CHECKSUM IS THE 16 BIT NEGATED CHECKSUM OF
  // 	THE WORD COUNT, THE LOAD ADDRESS AND THE D-RAM DATA
  // 	REPRESENTED IN 16 BIT FORMAT.
  //

  initial begin			// Load CRAM and DRAM before start of simulation
    dumpFD = $fopen("dump.log", "w");
    KLLoadRAMs();
  end

  always @(negedge clk60 && !didCRAMReadBack) begin
    tCRAM cw;
    tCRAMAddress adr;

    didCRAMReadBack = 1;

    adr[0] = kl10pv.crm_52.cr01_adr_00_b_h;
    adr[1] = kl10pv.crm_52.cr01_adr_01_b_h;
    adr[2] = kl10pv.crm_52.cr01_adr_02_b_h;
    adr[3] = kl10pv.crm_52.cr01_adr_03_b_h;
    adr[4] = kl10pv.crm_52.cr01_adr_04_b_h;
    adr[5] = kl10pv.crm_52.cr01_adr_05_b_h;
    adr[6] = kl10pv.crm_52.cr01_adr_06_b_h;
    adr[7] = kl10pv.crm_52.cr01_adr_07_b_h;
    adr[8] = kl10pv.crm_52.cr01_adr_08_b_h;
    adr[9] = kl10pv.crm_52.cr01_adr_09_b_h;
    adr[10] = kl10pv.crm_52.cr01_adr_10_b_h;

    cw[0] = kl10pv.crm_52.e59.q;
    cw[1] = kl10pv.crm_52.e48.q;
    cw[2] = kl10pv.crm_52.e4.q;
    cw[3] = kl10pv.crm_52.e17.q;

    cw[4] = kl10pv.crm_50.e59.q;
    cw[5] = kl10pv.crm_50.e48.q;
    cw[6] = kl10pv.crm_50.e4.q;
    cw[7] = kl10pv.crm_50.e17.q;

    cw[8] = kl10pv.crm_44.e59.q;
    cw[9] = kl10pv.crm_44.e48.q;
    cw[10] = kl10pv.crm_44.e4.q;
    cw[11] = kl10pv.crm_44.e17.q;

    cw[12] = kl10pv.crm_42.e59.q;
    cw[13] = kl10pv.crm_42.e48.q;
    cw[14] = kl10pv.crm_42.e4.q;
    cw[15] = kl10pv.crm_42.e17.q;

    cw[16] = kl10pv.crm_40.e59.q;
    cw[17] = kl10pv.crm_40.e48.q;
    cw[18] = kl10pv.crm_40.e4.q;
    cw[19] = kl10pv.crm_40.e17.q;


    cw[20] = kl10pv.crm_52.e55.q;
    cw[21] = kl10pv.crm_52.e41.q;
    cw[22] = kl10pv.crm_52.e10.q;
    cw[23] = kl10pv.crm_52.e24.q;

    cw[24] = kl10pv.crm_50.e55.q;
    cw[25] = kl10pv.crm_50.e41.q;
    cw[26] = kl10pv.crm_50.e10.q;
    cw[27] = kl10pv.crm_50.e24.q;

    cw[28] = kl10pv.crm_44.e55.q;
    cw[29] = kl10pv.crm_44.e41.q;
    cw[30] = kl10pv.crm_44.e10.q;
    cw[31] = kl10pv.crm_44.e24.q;

    cw[32] = kl10pv.crm_42.e55.q;
    cw[33] = kl10pv.crm_42.e41.q;
    cw[34] = kl10pv.crm_42.e10.q;
    cw[35] = kl10pv.crm_42.e24.q;

    cw[36] = kl10pv.crm_40.e55.q;
    cw[37] = kl10pv.crm_40.e41.q;
    cw[38] = kl10pv.crm_40.e10.q;
    cw[39] = kl10pv.crm_40.e24.q;


    cw[40] = kl10pv.crm_52.e56.q;
    cw[41] = kl10pv.crm_52.e42.q;
    cw[42] = kl10pv.crm_52.e11.q;
    cw[43] = kl10pv.crm_52.e25.q;

    cw[44] = kl10pv.crm_50.e56.q;
    cw[45] = kl10pv.crm_50.e42.q;
    cw[46] = kl10pv.crm_50.e11.q;
    cw[47] = kl10pv.crm_50.e25.q;

    cw[48] = kl10pv.crm_44.e56.q;
    cw[49] = kl10pv.crm_44.e42.q;
    cw[50] = kl10pv.crm_44.e11.q;
    cw[51] = kl10pv.crm_44.e25.q;

    cw[52] = kl10pv.crm_42.e56.q;
    cw[53] = kl10pv.crm_42.e42.q;
    cw[54] = kl10pv.crm_42.e11.q;
    cw[55] = kl10pv.crm_42.e25.q;

    cw[56] = kl10pv.crm_40.e56.q;
    cw[57] = kl10pv.crm_40.e42.q;
    cw[58] = kl10pv.crm_40.e11.q;
    cw[59] = kl10pv.crm_40.e25.q;


    cw[60] = kl10pv.crm_52.e49.q;
    cw[62] = kl10pv.crm_52.e18.q;

    cw[64] = kl10pv.crm_50.e49.q;
    cw[66] = kl10pv.crm_50.e18.q;

    cw[68] = kl10pv.crm_44.e49.q;
    cw[70] = kl10pv.crm_44.e18.q;

    cw[72] = kl10pv.crm_42.e49.q;
    cw[74] = kl10pv.crm_42.e18.q;

    cw[76] = kl10pv.crm_40.e49.q;
    cw[78] = kl10pv.crm_40.e18.q;

    cw[80] = kl10pv.cra_45.e9.q;
    cw[81] = kl10pv.cra_45.e29.q;
    cw[82] = kl10pv.cra_45.e14.q;
    cw[83] = kl10pv.cra_45.e25.q;
    cw[84] = kl10pv.cra_45.e10.q;
    cw[85] = kl10pv.cra_45.e15.q;

    $display("READ BACK %o: %o", adr, cw);
  end

  initial begin
    crobar_e_h = '1;
    repeat (100) @(negedge clk);
    crobar_e_h = '0;
  end

  always @(negedge crobar_e_h) begin
    repeat (10) @(negedge clk);
    KLMasterReset();
    KLSoftReset();

    // Start CPU in microcode halt loop.
    doDiagFunc(diagfCLR_RUN);
    doDiagFunc(diagfSTART_CLOCK);
    doDiagFunc(diagfCONTINUE);
  end


  ////////////////////////////////////////////////////////////////
  // Functions from KLINIT.L20 $KLMR (DO A MASTER RESET ON THE KL)
  task KLMasterReset;
    $display($time, " KLMasterReset() START");
    indent = "  ";

    // $DFXC(.CLRUN=010)    ; Clear run
    doDiagFunc(diagfCLR_RUN);

    // This is the first phase of DMRMRT table operations.
    doDiagWrite(diagfCLK_SRC_RATE, '0);		      // CLOCK LOAD FUNC #44
    doDiagFunc(diagfSTOP_CLOCK);                      // STOP THE CLOCK
    doDiagFunc(diagfSET_RESET);                       // SET RESET
    doDiagWrite(diagfRESET_PAR_REGS, '0);             // LOAD CLK PARITY CHECK & FS CHECK
    doDiagWrite(diagfMBOXDIS_PARCHK_ERRSTOP, '0);     // LOAD CLK MBOX CYCLE DISABLES,
    doDiagWrite(diagfBURST_CTR_RH, '0);		      // LOAD BURST COUNTER (8,4,2,1)
    doDiagWrite(diagfBURST_CTR_LH, '0);		      // LOAD BURST COUNTER (128,64,32,16)
    doDiagWrite(diagfSET_EBOX_CLK_DISABLES, '0);      // LOAD EBOX CLOCK DISABLE
    doDiagFunc(diagfSTART_CLOCK);                     // START THE CLOCK
    doDiagWrite(diagfINIT_CHANNELS, '0);              // INIT CHANNELS
    doDiagWrite(diagfBURST_CTR_RH, '0);		      // LOAD BURST COUNTER (8,4,2,1)

    // Loop up to three times:
    //   Do diag function 162 via $DFRD test (A CHANGE COMING A L)=EBUS[32]
    //   If not set, $DFXC(.SSCLK=002) to single step the MBOX
    $display($time, " [step up to 5 clocks to synchronize MBOX]");

    repeat (5) begin
      repeat (5) @(negedge clk);
      if (!a_change_coming) break;
      repeat (5) @(negedge clk);
      doDiagFunc(diagfSTEP_CLOCK);
    end

    if (a_change_coming) begin
      $display("===ERROR=== Step MBOX five times did not clear a_change_coming");
    end

    // Phase 2 from DMRMRT table operations.
    doDiagFunc(diagfCOND_STEP);          // CONDITIONAL SINGLE STEP
    doDiagFunc(diagfCLR_RESET);          // CLEAR RESET
    doDiagWrite(diagfENABLE_KL, '0);     // ENABLE KL STL DECODING OF CODES & AC'S
    doDiagWrite(diagfEBUS_LOAD, '0);     // SET KL10 MEM RESET FLOP
    doDiagWrite(diagfWRITE_MBOX, 'o120); // WRITE M-BOX

    $display($time, " DONE");
    indent = "";
  endtask


  ////////////////////////////////////////////////////////////////
  // Analogue of $KLSR routine (SOFT RESET FOR RAM LOADERS).
  task KLSoftReset();
    doDiagFunc(diagfSET_RESET);   // SET RESET.
    doDiagFunc(diagfSTART_CLOCK); // START THE CLOCK.
    doDiagFunc(diagfSTOP_CLOCK);  // STOP THE CLOCK.
    doDiagFunc(diagfCOND_STEP);   // CONDITIONAL SINGLE STEP.
    doDiagFunc(diagfCLR_RESET);   // CLEAR RESET.
  endtask


  ////////////////////////////////////////////////////////////////
  task automatic KLLoadRAMs;
    int fd;
    string line, recType, rec;
    string words[$];

    $display("[Reading KLX.RAM to load CRAM and DRAM]");

    fd = $fopen("./images/ucode/klx.ram", "r");
    if (fd == 0) $display("Could not open KLX.RAM file");

    // Read header line
    $fgets(line, fd);
    $display(line);		// TEMPORARY

    while (1) begin
      $fgets(line, fd);
      if ($feof(fd)) break;

      line = trimString(line);
      recType = line.substr(0, 0);
      rec = line.substr(2, line.len() - 1);
      words = split(rec, ",");

      case (recType)
      "Z": begin  		// Zero a range
	W16 adr = unASCIIize(words[1]);
	W16 cksum = unASCIIize(words[2]);
	W16 count = unASCIIize(words[3]);
	$display("CRAM zero adr=%07o cksum=%07o count=%d.", adr, cksum, count);
      end

      "C": begin		// CRAM record
	W16 count = unASCIIize(words[0]);
	W16 adr = unASCIIize(words[1]);
	W16 lastAdr = 0;

	if (count == 0 && adr == 0) begin
	  lastAdr = 0;
	end else begin
	  if (adr == 0) adr = lastAdr;
	  lastAdr = adr;
	  // $display("CRAM record count=%d lastAdr=%07o adr=%07o", count, lastAdr, adr);

	  for (int k = 2; k < count; ) begin
	    tCRAM rcw;
	    // These hard coded ranges of destination bits come from
	    // comment above on KLX.RAM format, except that the last
	    // piece appears to need to be six bits and not five based
	    // on PDF347 CRA5 {CALL,DISP[0:4]} "special" field.
	    cw[64:79] = unASCIIize(words[k++]);
	    cw[48:63] = unASCIIize(words[k++]);
	    cw[32:47] = unASCIIize(words[k++]);
	    cw[16:31] = unASCIIize(words[k++]);
	    cw[00:15] = unASCIIize(words[k++]);
	    cw[80:85] =  6'(unASCIIize(words[k++]));
	    $fwrite(dumpFD, "C %04o: SB %o\n", adr, cw);

	    if (adr == 16'o136) begin
	      cram136 = cw;
	    end else if (adr == 16'o137) begin
	      bit [0:5] majver;
	      bit [0:2] minver;
	      bit [0:8] edit;

	      cram137 = cw;
	      majver = {cram136[29:31], cram136[33:35]};
	      minver = cram136[37:39];
	      edit = {cram137[29:31], cram137[33:35], cram137[37:39]};
	      $display("CRAM version: %1o.%1o(%0o) - as written to CRAM",
		       majver, minver, edit);
	    end

//	    writeCRAM(cw, tCRAMAddress'(adr), dumpFD);
	    ++adr;
	  end
	end
      end

      "D": begin		// DRAM record
	W16 count = unASCIIize(words[0]);
	W16 adr16 = unASCIIize(words[1]);
	tDRAMAddress adr = adr16[7:0];
	tDRAMAddress lastAdr = 0;

	if (count == 0 && adr == 0) begin
	  //	    $display("DRAM EOF");
	  lastAdr = 0;
	end else begin
	  W36 diagW;

	  if (adr == 0) adr = lastAdr;

	  // These functions from PDF71-73 in `EK-OKL10-MG-003 KL10
	  // Maintenance Guide Volume 1 Rev 3 Apr85`.

	  // EBOX CONTROL
	  // Func  Name   Description
	  //  10  CLRRUN  Clear the RUN flop. Make the microcode go to the "halt loop".
	  //  11  SETRUN  Set the RUN flop. Allow repeated instruction execution.
	  //  12  CONBUT  Set the CONTINUE flop (momentary). Allow the microcode to
	  //		  leave the halt loop.
	  //  14  IRLTCH  Unlatch the IR and load it from the AD
	  //              (PDF128 via CON2 DIAG IR STROBE H).
	  //  15  DRLTCH  Unlatch the DRAM register and allow it to load from the RAMs.

	  // LOAD DRAM FUNCTIONS
	  // Func  Name   EBUS bits  Description
	  //  60  LDRAM1  12-14	   DRAM A00-02, even addresses
	  //		  15-17	   DRAM B00-02, even addresses
	  //			   kldcp.hlp.txt: LOAD A & B FIELDS EVEN
	  //  61  LDRAM2  12-14	   DRAM A00-02, odd addresses
	  //		  15-17	   DRAM B00-02, odd addresses
	  //			   kldcp.hlp.txt: LOAD A & B FIELDS ODD
	  //  62  LDRAM3  14-17	   Common J01-04
	  //			   kldcp.hlp.txt: LOAD COMMON J1-J4
	  //  63  LDRJEV  15-17	   J08-10, even addresses
	  //		  12	   parity bit, even addresses
	  //			   kldcp.hlp.txt: LOAD PARITY & J8-J10 EVEN
	  //  64  LDRJOD  14       Common J07 (NOTE: J05 and J06 do not exist.)
	  //		  15-17	   J08-10, odd addresses
	  //		  12	   parity bit, odd addresses
	  //			   kldcp.hlp.txt: LOAD PARITY & J8-J10 ODD

	  // IR, DRAM CONTROL FUNCTIONS
	  //  65  DISIOJ  Disable special decode of opcodes 254, 7XX.
	  //  66  DISACF  Disable IR AC outputs.
	  //  67  ENIOJA  Enable KL10 style decoding of opcodes and ACs.

	  // See MP00301_KL10PV_Jun80-OCR.pdf PDF130 for DRAM
	  // diagnostic write function decoder.

	  // KL10 I/O instructions defined in `1982_ProcRefMan.pdf`
	  // PDF192-196.

	  // NOTE: IRD board N=12.
	  //
	  // See `rtl/doc/kldcp.doc` for a lot more information on
	  // this format. Search for "MICRO FORMAT FOR WDRAM". This
	  // entire document is an excellent introduction to the
	  // operation of the KL10 via its front end, but the code it
	  // describes is not from the same era (and is not derived
	  // from the same code base). It also documents the
	  // correspondence between hardware RAM bits and the
	  // microcode fields they contain, which is a jumbled rehash
	  // of the bit order created from the microcode sources by
	  // the microcode assembly process.

	  for (int k = 2; k < count; ) begin
 	    W16 even, odd, common;

	    even   = unASCIIize(words[k++]);
	    odd    = unASCIIize(words[k++]);
	    common = unASCIIize(words[k++]);

	    $fwrite(dumpFD, "D %03o: %05o %05o %05o\n", adr, even, odd, common);

/*
MICRO FORMAT
FOR WDRAM

   15 -/- 13---11   10----8   7   6    5    4    3     2     1     0
	---------------------------------------------------------------
 +0	* -- A -- * -- B -- *   *   *  P  *   * ------ J FIELD ------ *
 EVEN	* 1  2  3 * 1  2  3 *   *   *  E  *   *  7  *  8  *  9  *  10 *
	***************************************************************

   15 -/- 13---11   10----8   7   6    5    4    3     2     1     0
	---------------------------------------------------------------
 +2	* -- A -- * -- B -- *   *   *  P  *   * ------ J FIELD ------ *
 ODD	* 1  2  3 * 1  2  3 *   *   *  O  *   *  7  *  8  *  9  *  10 *
	***************************************************************

   15 -/-                                         3     2     1     0
	                                      -------------------------
 +4 	                                      * ------ J FIELD ------ *
 COMMON	                                      *  1  *  2  *  3  *  4  *
	                                      *************************

	NOTE: J7 ALSO COMMON BIT WRITTEN BY ODD WORD
	      J5 & J6 DO NOT EXIST

*/
	    writeDRAM(adr, even, odd, common);
	    adr = adr + 2;
	  end

	  lastAdr = adr;
	  //	    $display("DRAM record count=%d lastAdr=%07o adr=%07o", count, lastAdr, adr);
	end
      end

      ";": ;			// Comment - ignore

      default:
	$display("ERROR: Unknown record type '%s' in KLX.RAM file", recType);
      endcase
    end

    $display("[loading test loop microcode]");
    cw = 0;
    cw[5:15] = 'o123;
    writeCRAM(cw, 0, dumpFD);
    cw[5:15] = 'o555;
    writeCRAM(cw, 11'o123, dumpFD);
    cw[5:15] = 0;
    writeCRAM(cw, 'o555, dumpFD);
    cw[5:15] = 'o556;
    writeCRAM(cw, 'o556, dumpFD);
    cw[5:15] = 'o557;
    writeCRAM(cw, 'o557, dumpFD);

    $fclose(fd);
    $fclose(dumpFD);
  endtask // KLLoadRAMs


  ////////////////////////////////////////////////////////////////
  // Write specified CRAM word to specified CRAM address.  Composed
  // while looking at klinit.l20 $WCRAM and various other sources..
  //
  // CRM4 is PDF395. See decoder E1 on PDF393 for diag func decode and
  // corresponding bits.
  //
  // CRA5 is PDF347. This for the CALL+DISP[0:5] bits.
  // CRM52: N=0
  // CRM50: N=4
  // CRM44: N=8
  // CRM42: N=12
  // CRM40: N=16
  task automatic writeCRAM(tCRAM cw, tCRAMAddress adr, int dumpFD);
    $fwrite(dumpFD, "WC: ");

    `define putCRM1(N, slot, a0, b0)		\
	if (adr[10] == 0)			\
	  kl10pv.slot.a0.ram[adr[0:9]] = cw[N];	\
	else					\
	  kl10pv.slot.b0.ram[adr[0:9]] = cw[N];	\
      $fwrite(dumpFD, " %2d:%3s=%o\n", N, adr[10] ? `STRINGIFY(b0) : `STRINGIFY(a0), cw[N]);

    `define putCRM2(N, slot, a0, b0, a1, b1)	\
      `putCRM1(N+0, slot, a0, b0)		\
      `putCRM1(N+1, slot, a1, b1)

    `define putCRM4(N, slot, a0, b0, a1, b1, a2, b2, a3, b3)	\
      `putCRM2(N+0, slot, a0, b0, a1, b1)			\
      `putCRM2(N+2, slot, a2, b2, a3, b3)

    `define putCRM20(N, a0, b0, a1, b1, a2, b2, a3, b3)		\
      `putCRM4(N+0,  crm_52, a0, b0, a1, b1, a2, b2, a3, b3)	\
      `putCRM4(N+4,  crm_50, a0, b0, a1, b1, a2, b2, a3, b3)	\
      `putCRM4(N+8,  crm_44, a0, b0, a1, b1, a2, b2, a3, b3)	\
      `putCRM4(N+12, crm_42, a0, b0, a1, b1, a2, b2, a3, b3)	\
      `putCRM4(N+16, crm_40, a0, b0, a1, b1, a2, b2, a3, b3)

    `putCRM20(0,  e59, e57, e48, e44,  e4,  e2, e17, e14)
    `putCRM20(20, e55, e51, e41, e37, e10,  e7, e24, e21)
    `putCRM20(40, e56, e52, e42, e38, e11,  e8, e25, e22)

    `putCRM2(60, crm_52, e49, e45, e18, e15)
    `putCRM2(64, crm_50, e49, e45, e18, e15)
    `putCRM2(68, crm_44, e49, e45, e18, e15)
    `putCRM2(72, crm_42, e49, e45, e18, e15)
    `putCRM2(76, crm_40, e49, e45, e18, e15)

    // CRA for the last six bits
    `putCRM1(80, cra_45,  e9,  e4)
    `putCRM1(81, cra_45, e29, e24)
    `putCRM1(82, cra_45, e14, e19)
    `putCRM1(83, cra_45, e25, e30)
    `putCRM1(84, cra_45, e10,  e5)
    `putCRM1(85, cra_45, e15, e20)
    $fwrite(dumpFD, "\n");
  endtask // writeCRAM


  ////////////////////////////////////////////////////////////////
  // Write specified DRAM word (even, odd, and common bits) to specified DRAM
  // address.  Composed while looking at klinit.l20 $WDRAM and various other
  // sources.  ICD2 is PDF129.
  task automatic writeDRAM(tDRAMAddress adr, W16 e, W16 o, W16 c);

    `define putDRAMEOBit(ADR, EE, EO, BE, BO)	\
      kl10pv.ird_48.EE.ram[ADR] = BE;		\
      kl10pv.ird_48.EO.ram[ADR] = BO;

    `putDRAMEOBit(adr,  e4,  e9, e[13], o[13])
    `putDRAMEOBit(adr, e42, e47, e[12], o[12])
    `putDRAMEOBit(adr, e14, e19, e[11], o[11])
    `putDRAMEOBit(adr, e24, e29, e[10], o[10])
    `putDRAMEOBit(adr, e34, e37, e[9], o[9])
    `putDRAMEOBit(adr, e43, e48, e[8], o[8])

    `putDRAMEOBit(adr, e25, e30, e[2], o[2])
    `putDRAMEOBit(adr, e35, e38, e[1], o[1])
    `putDRAMEOBit(adr, e53, e58, e[0], o[0])
    `putDRAMEOBit(adr,  e3,  e8, e[5], o[5])

    kl10pv.ird_48.e20.ram[adr] = o[3];
    kl10pv.ird_48.e13.ram[adr] = c[3];
    kl10pv.ird_48.e18.ram[adr] = c[2];
    kl10pv.ird_48.e28.ram[adr] = c[1];
    kl10pv.ird_48.e23.ram[adr] = c[0];
  endtask // writeDRAM


  ////////////////////////////////////////////////////////////////
  // Read from previously specified address (see
  // `setCRAMDiagAddress()`) a full CRAM word into `cw`.
  task automatic readCRAM();
    W36 readResult;

    doDiagRead(diagfCRAM_READ_00_19, readResult);
    cw[00:03] = readResult[08:11];
    cw[04:07] = readResult[14:17];
    cw[08:11] = readResult[20:23];
    cw[12:15] = readResult[26:29];
    cw[16:19] = readResult[32:35];

    doDiagRead(diagfCRAM_READ_20_39, readResult);
    cw[20:23] = readResult[08:11];
    cw[24:27] = readResult[14:17];
    cw[28:31] = readResult[20:23];
    cw[32:35] = readResult[26:29];
    cw[36:39] = readResult[32:35];

    doDiagRead(diagfCRAM_READ_40_59, readResult);
    cw[40:43] = readResult[08:11];
    cw[44:47] = readResult[14:17];
    cw[48:51] = readResult[20:23];
    cw[52:55] = readResult[26:29];
    cw[56:59] = readResult[32:35];

    doDiagRead(diagfCRAM_READ_60_79, readResult);
    cw[60:63] = readResult[08:11];
    cw[64:67] = readResult[14:17];
    cw[68:71] = readResult[20:23];
    cw[72:75] = readResult[26:29];
    cw[76:79] = readResult[32:35];

    doDiagRead(diagfCRAM_READ_80_85, readResult);
    cw[80:85] = readResult[00:05];
  endtask // readCRAM


  ////////////////////////////////////////////////////////////////
  // Write the specified diagnostic function with data on ebus as if
  // we were the front-end setting up a KL10-PV.
  task doDiagWrite(input tDiagFunction func, input W36 ebusData);

    @(negedge clk) begin
      ebus.ds <= func;
      ebus.diagStrobe <= 1;
      EBUSdriver.data <= ebusData;
      EBUSdriver.driving <= 1;
    end

    @(negedge clk) ;
    @(negedge clk) ebus.diagStrobe <= 0;
    @(negedge clk) EBUSdriver.driving <= 0;
    @(posedge clk) ;
  endtask


  ////////////////////////////////////////////////////////////////
  // Request the specified diagnostic function as if we were the
  // front-end setting up a KL10-PV.
  task doDiagFunc(input tDiagFunction func);

    @(negedge clk) begin
      ebus.ds <= func;
      ebus.diagStrobe <= 1;            // Strobe this
    end

    repeat (16) @(negedge clk) ;
    @(negedge clk) ebus.diagStrobe <= 0;
    @(posedge clk);
  endtask // doDiagFunc


  ////////////////////////////////////////////////////////////////
  // Read using the specified diagnostic function with data on ebus as
  // if we were the front-end.
  task automatic doDiagRead(input tDiagFunction func, output W36 result);

    @(negedge clk) begin
      ebus.ds <= func;
      ebus.diagStrobe <= 1;
    end

    @(negedge clk) ;
    @(negedge clk) result <= ebus.data;
    @(posedge clk) ebus.diagStrobe <= 0;
  endtask


  // Decode a single word (i.e., from `convrt.txt` section 3.0) and
  // return its value.
  function automatic W16 unASCIIize(string s);
    W16 v = 0;
    int shift = 0;

    for (int k = s.len() - 1; k >= 0; --k) begin
      W16 ch = W16'(s[k]);
      v = v | ((ch & ~'o100) << shift);
      shift += 6;
    end

    return v;
  endfunction // unASCIIize


  // Trim a string
  function string trimString(string s);
    int   first;
    int   last;
    first = 0;
    last  = s.len-1;
    while ((first <= last) && isSpace(s[first])) first++;
    while ((first <= last) && isSpace(s[last])) last--;
    return s.substr(first, last);
  endfunction


  function automatic bit isSpace(byte unsigned ch);
    return ch == "\t" || ch == "\n" || ch == " " || ch == 13;
  endfunction: isSpace


  // Split a string on every occurrence of a given character
  typedef string qs[$];
  function automatic qs split(string s, string splitset="");
    int 	 anchor = 0;
    bit 	 splitchars[string];
    qs result = {};

    foreach (splitset[i]) splitchars[splitset[i]] = 1;

    foreach (s[i]) begin

      if (splitchars.exists(s[i]) != 0) begin
        result.push_back(s.substr(anchor, i - 1));
        anchor = i + 1;
      end
    end

    result.push_back(s.substr(anchor, s.len() - 11));
    return result;
  endfunction


  // Replace the first instance of `find` in `s` with `repl` or return
  // `s` unchanged if not present.
  function automatic string replace(string s, string find, string repl);
    int startX = 0;
    int replX = 0;

    for (int k = 0; k < s.len(); ++k) begin

      if (s[k] == find[replX]) begin
        if (replX == 0) startX = k;
        ++replX;

        if (replX == find.len()) begin // Success! Return s with find replaced by repl
          return {s.substr(0, startX-1), repl, s.substr(startX+find.len(), s.len()-1)};
        end

      end else if (replX != 0) begin
        // Entire find string didn't match, so reset.
        replX = 0;
        k = startX;
      end
    end

    return s;                   // Not found, return s unmodified
  endfunction

endmodule; // fe_sim
