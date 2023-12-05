// Simulate the front end functions we need to test the KL10-PV.

`include "kl10pv.svh"
`include "dte.svh"

typedef bit [0:8] tDRAMAddress;

`define STRINGIFY(S)	`"S`"


// Here `clk` is the `CLK 10/11 CLK H` from the CLK module PDF169.
module fe_sim(input bit clk,
	      input bit clk60,
	      inout 	 iEBUS ebus,
	      output 	 tEBUSdriver EBUSdriver,
	      input 	 mbc3_a_change_coming_a_l,
	      input	 con_ebox_halted_h,
	      output bit crobar_e_h,
	      output bit con_cono_200000_h);

  tCRAM cw;
  tCRAM cram136;
  tCRAM cram137;

  W36 startAddr = 0;

  bit a_change_coming;

  bit dumpCRAM = 0;
  bit dumpDRAM = 0;
  bit dumpCRA_ADR = 1;
  bit dumpDiagFuncs = 1;
  bit dumpLoadMem = 1;

  int dumpFD;

  always_comb a_change_coming = !mbc3_a_change_coming_a_l;

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
  // 	80-85	;C-RAM BITS AS SPECIFIED UNDER "WCRAM"
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

  initial begin
    dumpFD = $fopen("dump.log", "w");
  end

  final begin
    if (dumpFD != 0) $fclose(dumpFD);
  end

  initial begin			// Load CRAM and DRAM before start of simulation
    loadRAMs();
    loadDiagnostic("images/klddt/klddt.a10");
  end

  initial begin
    crobar_e_h = '1;
    repeat (20) @(negedge clk);
    crobar_e_h = '0;
  end

  always @(negedge crobar_e_h) begin
    repeat (10) @(negedge clk);
    KLMasterReset();
    KLSoftReset();
    startKLBoot(startAddr);
  end


  task startKLBoot(W36 startAddr);
    // Zero ACs
    for (int ac = 0; ac < 16; ++ac) loadAC(ac, '0);

    execKLInstr(36'o700200_267760);	// CONO APR,267760	; Reset APR
    execKLInstr(36'o700600_010000);	// CONO PI,10000	; Reset PI
    execKLInstr(36'o701200_000000);	// CONO PAG,0		; Clear paging system
    execKLInstr(36'o701140_000000);	// DATAO PAG,0		; Clear user base

    // Set AC0 to hold flag to run boot loader.
    loadAC(0, 36'o400000_000000);

    // Enable parity checking on CRAM, DRAM, FS, AR/ARX
    doDiagWrite(diagfRESET_PAR_REGS, 'o16);

    // Start clocks
    doDiagFunc(diagfSTART_CLOCK);

    $display("%7g [bootstrap loaded and started]", $realtime);
  endtask // startKLBoot


  ////////////////////////////////////////////////////////////////
  // Functions from KLINIT.L20 $KLMR (DO A MASTER RESET ON THE KL)
  task KLMasterReset;
    doDiagFunc(diagfCLR_RUN);

    // This is the first phase of DMRMRT table operations.
    doDiagWrite(diagfCLK_SRC_RATE, '0);		      // CLOCK LOAD FUNC #44
    doDiagFunc(diagfSTOP_CLOCK);                      // STOP THE CLOCK
    doDiagFunc(diagfSET_RESET);                       // SET RESET
    doDiagWrite(diagfRESET_PAR_REGS, '0);             // LOAD CLK PARITY CHECK & FS CHECK
    doDiagWrite(diagfMBOXDIS_PARCHK_ERRSTOP, '0);     // LOAD CLK MBOX CYCLE DISABLES,
						      // PARITY CHECK, ERROR STOP ENABLE
    doDiagWrite(diagfBURST_CTR_RH, '0);		      // LOAD BURST COUNTER (8,4,2,1)
    doDiagWrite(diagfBURST_CTR_LH, '0);		      // LOAD BURST COUNTER (128,64,32,16)
    doDiagWrite(diagfSET_EBOX_CLK_DISABLES, '0);      // LOAD EBOX CLOCK DISABLE
    doDiagFunc(diagfSTART_CLOCK);                     // START THE CLOCK
    doDiagWrite(diagfINIT_CHANNELS, '0);              // INIT CHANNELS
    doDiagWrite(diagfBURST_CTR_RH, '0);		      // LOAD BURST COUNTER (8,4,2,1)

    // Loop up to five (was three in RSX20F) times:
    //   Test MBC3 A CHANGE COMING A L (we have active-high a_change_coming).
    //   If not asserted, single step the MBOX and try again.
    $display("%7g [start MBOX sync]", $realtime);

    for (int tries = 0; tries < 5; ++tries) begin
      repeat (5) @(negedge clk) ;

      @(negedge clk) begin

	if (tries >= 5 && !a_change_coming) begin
	  $display("===ERROR=== Step MBOX %d times did not clear a_change_coming", tries);
	  break;
	end
      end
      
      repeat (5) @(negedge clk) ;

      doDiagFunc(diagfSTEP_CLOCK);
    end

    $display("%7g [end MBOX sync]", $realtime);

    // Phase 2 from DMRMRT table operations.
    doDiagFunc(diagfCOND_STEP);          // CONDITIONAL SINGLE STEP
    doDiagFunc(diagfCLR_RESET);          // CLEAR RESET
    doDiagWrite(diagfENABLE_KL, '0);     // ENABLE KL STL DECODING OF CODES & AC'S
    doDiagWrite(diagfMEM_RESET, '0);	 // SET KL10 MEM RESET FLOP
    doDiagWrite(diagfWRITE_MBOX, 'o120); // WRITE M-BOX

    $display("%7g [master reset complete]", $realtime);
  endtask


  ////////////////////////////////////////////////////////////////
  // Analogue of $KLSR routine (SOFT RESET FOR RAM LOADERS).
  task KLSoftReset();
    doDiagFunc(diagfSET_RESET);   // SET RESET.
    doDiagFunc(diagfSTART_CLOCK); // START THE CLOCK.
    doDiagFunc(diagfSTOP_CLOCK);  // STOP THE CLOCK.
    doDiagFunc(diagfCOND_STEP);   // CONDITIONAL SINGLE STEP.
    doDiagFunc(diagfCLR_RESET);   // CLEAR RESET.
    $display("%7g [soft reset complete]", $realtime);
  endtask

  
  // Assuming clock is disabled, set specified AC to specified value.
  task automatic loadAC(int ac, W36 value);
    kl10pv.edp_53.e69.ram[ac] = value[0];
    kl10pv.edp_53.e70.ram[ac] = value[1];
    kl10pv.edp_53.e71.ram[ac] = value[2];
    kl10pv.edp_53.e72.ram[ac] = value[3];
    kl10pv.edp_53.e65.ram[ac] = value[4];
    kl10pv.edp_53.e58.ram[ac] = value[5];

    kl10pv.edp_51.e69.ram[ac] = value[6];
    kl10pv.edp_51.e70.ram[ac] = value[7];
    kl10pv.edp_51.e71.ram[ac] = value[8];
    kl10pv.edp_51.e72.ram[ac] = value[9];
    kl10pv.edp_51.e65.ram[ac] = value[10];
    kl10pv.edp_51.e58.ram[ac] = value[11];

    kl10pv.edp_49.e69.ram[ac] = value[12];
    kl10pv.edp_49.e70.ram[ac] = value[13];
    kl10pv.edp_49.e71.ram[ac] = value[14];
    kl10pv.edp_49.e72.ram[ac] = value[15];
    kl10pv.edp_49.e65.ram[ac] = value[16];
    kl10pv.edp_49.e58.ram[ac] = value[17];

    kl10pv.edp_43.e69.ram[ac] = value[18];
    kl10pv.edp_43.e70.ram[ac] = value[19];
    kl10pv.edp_43.e71.ram[ac] = value[20];
    kl10pv.edp_43.e72.ram[ac] = value[21];
    kl10pv.edp_43.e65.ram[ac] = value[22];
    kl10pv.edp_43.e58.ram[ac] = value[23];

    kl10pv.edp_41.e69.ram[ac] = value[24];
    kl10pv.edp_41.e70.ram[ac] = value[25];
    kl10pv.edp_41.e71.ram[ac] = value[26];
    kl10pv.edp_41.e72.ram[ac] = value[27];
    kl10pv.edp_41.e65.ram[ac] = value[28];
    kl10pv.edp_41.e58.ram[ac] = value[29];

    kl10pv.edp_39.e69.ram[ac] = value[30];
    kl10pv.edp_39.e70.ram[ac] = value[31];
    kl10pv.edp_39.e71.ram[ac] = value[32];
    kl10pv.edp_39.e72.ram[ac] = value[33];
    kl10pv.edp_39.e65.ram[ac] = value[34];
    kl10pv.edp_39.e58.ram[ac] = value[35];
  endtask // loadAC


  // $EXCT -- EXECUTE KL INSTRUCTION
  //
  // Execute a single KL instruction by getting the KL into the halt
  // loop, loading the AR with the instruction, pushing the CONTINUE
  // button, and starting up the clock. The routine completes when the
  // microcode reaches the halt loop again.
  task automatic execKLInstr(W36 instr);
    loadAR(instr);		// Load AR with the instruction
    doDiagFunc(diagfCONTINUE);	// Push CONTINUE button
    doDiagFunc(diagfSTART_CLOCK); // Start the clocks

    // Wait for KL to halt again
    @(posedge clk) if (con_ebox_halted_h) return;
  endtask // execKLInstr


  task automatic loadAR(W36 ar);
    if (dumpDiagFuncs) $fdisplay (dumpFD, "Load AR %06o,,%06o", ar[0:17], ar[18:35]);
    doDiagWrite(diagfLOAD_AR, ar);
  endtask // loadAR


  ////////////////////////////////////////////////////////////////
  task automatic loadRAMs;
    int fd;
    string line, recType, rec;
    string words[$];
    string letters[1:10] = {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J"};

    $display("%7g [Reading KLX.RAM to load CRAM and DRAM]", $realtime);

    fd = $fopen("./images/ucode/klx.ram", "r");
    if (fd == 0) $display("Could not open KLX.RAM file");

    // Read header line
    $fgets(line, fd);

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

	  for (int k = 2; k < count; ) begin
	    tCRAM rcw;
	    // These hard coded ranges of destination bits come from
	    // comment above on KLX.RAM format, except that the last
	    // piece really needs six bits and not five. This belief
	    // is based on PDF347 CRA5 {CALL,DISP[0:4]} "special"
	    // field for bits 80-85.
	    cw[64:79] = unASCIIize(words[k++]);
	    cw[48:63] = unASCIIize(words[k++]);
	    cw[32:47] = unASCIIize(words[k++]);
	    cw[16:31] = unASCIIize(words[k++]);
	    cw[00:15] = unASCIIize(words[k++]);
	    cw[80:85] =  6'(unASCIIize(words[k++]));

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
	      $display("%7g [KL10 microcode V%1o%s(%0o)]",
		       $realtime, majver, letters[minver], edit);
	    end

	    writeCRAM(cw, tCRAMAddress'(adr));
	    ++adr;
	  end
	end
      end

      "D": begin		// DRAM record
	W16 count = unASCIIize(words[0]);
	W16 adr16 = unASCIIize(words[1]);
	W16 lastAdr = 0;

	if (count == 0 && adr16 == 0) begin
	  lastAdr = 0;
	end else begin

	  if (adr16 == 0) adr16 = lastAdr;

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

	  for (int k = 2; k < count; k += 3) begin
 	    W16 even, odd, common;

	    even   = unASCIIize(words[k+0]);
	    odd    = unASCIIize(words[k+1]);
	    common = unASCIIize(words[k+2]);

	    if (dumpDRAM) $fdisplay(dumpFD, "DRAM %o pair even=%o'%s' odd=%o'%s' common=%o'%s'",
				    adr16, even, words[k+0], odd, words[k+1], common, words[k+2]);
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
	    writeDRAM(adr16, even, odd, common);
	    adr16 += 2;
	  end

	  lastAdr = adr16;
	end
      end

      ";": ;			// Comment - ignore

      default:
	$display("ERROR: Unknown record type '%s' in KLX.RAM file", recType);
      endcase
    end

    $fclose(fd);
  endtask // loadRAMs


  typedef bit [0:39] W40;


  // Load the specified *.A10 file diagnostic.

  /*
        PDP-10 ASCIIZED FILE FORMAT
        ---------------------------

        PDP-10 ASCIIZED FILES ARE COMPOSED OF THREE TYPES OF
        FILE LOAD LINES.  THEY ARE:

        A.      CORE ZERO LINE

        THIS LOAD FILE LINE SPECIFIES WHERE AND HOW MUCH PDP-10 CORE
        TO BE ZEROED.  THIS IS NECESSARY AS THE PDP-10 FILES ARE
        ZERO COMPRESSED WHICH MEANS THAT ZERO WORDS ARE NOT INCLUDED
        IN THE LOAD FILE TO CONSERVE FILE SPACE.

          CORE ZERO LINE

                Z WC,ADR,COUNT,...,CKSUM

                Z = PDP-10 CORE ZERO
                WORD COUNT = 1 TO 4
                ADR = ZERO START ADDRESS
                        DERIVED FROM C(JOBSA)
                COUNT = ZERO COUNT, 64K MAX
                        DERIVED FROM C(JOBFF)

        IF THE ADDRESSES ARE GREATER THAN 64K THE HI 2-BITS OF
        THE 18 BIT PDP-10 ADDRESS ARE INCLUDED AS THE HI-BYTE OF
        THE WORD COUNT.
      DECSYSTEM10 KL10 DIAGNOSTIC CONSOLE PROGRAM
        -------------------------------------------

17.0    PDP-10 FILE FORMATS (CON'T)

        B.      LOAD FILE LINES

        AS MANY OF THESE TYPES OF LOAD FILE LINES ARE REQUIRED AS ARE
        NECESSARY TO REPRESENT THE BINARY SAVE FILE.

          LOAD FILE LINE

                T WC,ADR,DATA 20-35,DATA 4-19,DATA 0-3, - - - ,CKSUM

                T = PDP-10 TYPE FILE
                WC = PDP-10 DATA WORD COUNT TIMES 3, 3 PDP-11 WORDS
                     PER PDP-10 WORD.
                ADR = PDP-10 ADDRESS FOR THIS LOAD FILE LINE
                        LOW 16 BITS OF THE PDP-10 18 BIT ADDRESS, IF
                        THE ADDRESS IS GREATER THAN 64K, THE HI 2-BITS
                        OF THE ADDRESS ARE INCLUDED AS THE HI-BYTE OF
                        THE WORD COUNT.

                UP TO 8 PDP-10 WORDS, OR UP TO 24 PDP-11 WORDS

                DATA 20-35
                DATA  4-19      ;PDP-10 EQUIV DATA WORD BITS
                DATA  0-3

                CKSUM = 16 BIT NEGATED CHECKSUM OF WC, ADR & DATA

        C.      TRANSFER LINE

        THIS LOAD FILE LINE CONTAINS THE FILE STARTING ADDRESS.

          TRANSFER LINE

                T 0,ADR,CKSUM

                0 = WC = SIGNIFIES TRANSFER, EOF
                ADR = PROGRAM START ADDRESS

   */
  task automatic loadDiagnostic(string path);
    W36 w;
    W36 adr;
    string line, recType, rec;
    string words[$];

    int fd = $fopen(path, "r");
    $fgets(line, fd);		// Skip header line
    startAddr = 0;
    adr = 0;

    while (1) begin
      int k;
      W16 wc;

      $fgets(line, fd);
      if ($feof(fd)) break;

      line = trimString(line);
      recType = line.substr(0, 0);
      rec = line.substr(2, line.len() - 1);
      words = split(rec, ",");
      wc = unASCIIize(words[0]);
      adr = W36'({wc[15:14], unASCIIize(words[1])});
      wc = {2'b0, wc[13:0]};		// Scrub off high adr bits from word count

      case (recType)
      "Z": begin  		// Zero a range
	int zeroCount;
	zeroCount = int'(unASCIIize(words[2]));
	if (zeroCount == 0) zeroCount = 64*1024;
	for (W36 offset = 0; offset < W36'(zeroCount); ++offset) writeMem(adr + offset, 0);
      end

      "T": begin
	if (wc == 0) startAddr = adr;

	for (W36 offset = 0; offset < W36'(wc); ++offset) begin
	  int k;
	  W16 w0, w1, w2;

	  k = 2 + int'(offset*3);

	  w0 = unASCIIize(words[k+0]);
	  w1 = unASCIIize(words[k+1]);
	  w2 = unASCIIize(words[k+2]);
	  w = {w2[3:0], w1, w0};
	  writeMem(adr + offset, w);
	end
      end
      endcase
    end

    $fclose(fd);
    $display("%7g [loaded %s with start=%o]", $realtime, path, startAddr);
  endtask // loadDiagnostic


  task automatic writeMem(W36 adr, W36 value);
    kl10pv.memory0.mem[adr] = value;
    if (dumpLoadMem && value != 0) $fdisplay(dumpFD, "MEM %08o: %o", adr, value);
  endtask // writeMem



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
  task automatic writeCRAM(tCRAM cw, tCRAMAddress adr);

    `define putCRM1(N, slot, a0, b0)		\
	if (adr[10] == 0)			\
	  kl10pv.slot.a0.ram[adr[0:9]] = cw[N];	\
	else					\
	  kl10pv.slot.b0.ram[adr[0:9]] = cw[N];

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

    if (dumpCRAM) $fdisplay(dumpFD, "CRAM %04o: %o", int'(adr), cw);

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
  endtask // writeCRAM


  ////////////////////////////////////////////////////////////////
  // Write specified DRAM word (even, odd, and common bits) to specified DRAM
  // address.  Composed while looking at klinit.l20 $WDRAM and various other
  // sources.  IRD2 is PDF129.
  /*
  MICRO FORMAT
  FOR WDRAM

   15 -/- 13---11   10----8   7   6    5    4    3     2     1     0
        ---------------------------------------------------------------
        * -- A -- * -- B -- *   *   *  P  *   * ------ J FIELD ------ *
   EVEN * 1  2  3 * 1  2  3 *   *   *  E  *   *  7  *  8  *  9  *  10 *
        ***************************************************************

   15 -/- 13---11   10----8   7   6    5    4    3     2     1     0
        ---------------------------------------------------------------
        * -- A -- * -- B -- *   *   *  P  *   * ------ J FIELD ------ *
   ODD  * 1  2  3 * 1  2  3 *   *   *  O  *   *  7  *  8  *  9  *  10 *
        ***************************************************************

     15 -/-                                      3     2     1     0
                                              -------------------------
                                              * ------ J FIELD ------ *
   COMMON                                     *  1  *  2  *  3  *  4  *
                                              *************************

          NOTE: J7 ALSO COMMON BIT WRITTEN BY ODD WORD
                J5 & J6 DO NOT EXIST
  */
  task automatic writeDRAM(W16 adr16, W16 e, W16 o, W16 c);
    bit [0:7] ea = adr16[8:1];

    if (adr16[0]) $display("============== ERROR: writeDRAM called for odd 'adr' %3o", adr16);

    if (dumpDRAM) begin
      $fdisplay(dumpFD, "DRAM EVEN %03o A=%d%d%d B=%d%d%d P=%o J=%4o ea=%o",
		adr16, e[13], e[12], e[11], e[10], e[9], e[8], e[5],
		{c[3:0], 2'b0, e[3:0]}, ea);
      $fdisplay(dumpFD, "DRAM ODD  %03o A=%d%d%d B=%d%d%d P=%o J=%4o",
		adr16+1, o[13], o[12], o[11], o[10], o[9], o[8], o[5], {c[3:0], 2'b0, o[3:0]});
    end

    `define putDRAMEOBit(ADR, EE, EO, BE, BO)	\
      kl10pv.ird_48.EE.ram[ADR] = BE;		\
      kl10pv.ird_48.EO.ram[ADR] = BO;

    `putDRAMEOBit(ea,  e4,  e9, e[13], o[13]) // DRAM A00 X/Y H
    `putDRAMEOBit(ea, e42, e47, e[12], o[12]) // DRAM A01 X/Y H
    `putDRAMEOBit(ea, e14, e19, e[11], o[11]) // DRAM A02 X/Y H
    `putDRAMEOBit(ea, e24, e29, e[10], o[10]) // DRAM B00 X/Y H
    `putDRAMEOBit(ea, e34, e37, e[9], o[9])   // DRAM B01 X/Y H
    `putDRAMEOBit(ea, e43, e48, e[8], o[8])   // DRAM B02 X/Y H

    // J00 doesn't exist in DRAM
    kl10pv.ird_48.e13.ram[ea] = c[3];	      // DRAM J01 H
    kl10pv.ird_48.e18.ram[ea] = c[2];	      // DRAM J02 H
    kl10pv.ird_48.e28.ram[ea] = c[1];	      // DRAM J03 H
    kl10pv.ird_48.e23.ram[ea] = c[0];	      // DRAM J04 H
    // J05 and J06 "DO NOT EXIST"
    kl10pv.ird_48.e20.ram[ea] = o[3];	      // DRAM J07 H
    `putDRAMEOBit(ea, e25, e30, e[2], o[2])   // DRAM J08 X/Y H
    `putDRAMEOBit(ea, e35, e38, e[1], o[1])   // DRAM J09 X/Y H
    `putDRAMEOBit(ea, e53, e58, e[0], o[0])   // DRAM J10 X/Y H

    `putDRAMEOBit(ea,  e3,  e8, e[5], o[5])   // DRAM PAR X/Y H
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
  // Return standard comma-comma LH,,RH for 36 bit word as a string.
  function automatic string fmt36(W36 w);
    return $sformatf("%06o,,%06o", w[0:17], w[18:35]);
  endfunction // fmt36


  ////////////////////////////////////////////////////////////////
  // Write the specified diagnostic function with data on ebus as if
  // we were the front-end setting up a KL10-PV.
  task doDiagWrite(input tDiagFunction func, input W36 ebusData);
    if (dumpDiagFuncs) $fdisplay(dumpFD, "%7g %-30s %s", $realtime, func.name, fmt36(ebusData));

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
    if (dumpDiagFuncs) $fdisplay(dumpFD, "%7g %s", $realtime, func.name);

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
      v |= (ch & 16'o77) << shift;
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


  function automatic W36 b36(int b);
    return (36'o1 << 35) >> b;
  endfunction // b36

endmodule; // fe_sim
