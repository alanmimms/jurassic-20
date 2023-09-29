// Simulate the front end functions we need to test the KL10-PV.

`include "kl10pv.svh"
`include "dte.svh"

// Here `clk` is the `CLK 10/11 CLK H` from the CLK module PDF169.
module fe_sim(input bit clk,
	      inout 	 iEBUS ebus,
	      output 	 tEBUSdriver EBUSdriver,
	      input 	 mbc3_a_change_coming_a_l,
	      input 	 a_change_coming_in_l,
	      output bit crobar_e_h,
	      output bit con_cono_200000_h);

  string 		 indent = "";

  int 			 dumpLogFD;

  tCRAM cw;
  tCRAM cram136;
  tCRAM cram137;

  bit 			 a_change_coming, a_change_coming_in;
  always_comb a_change_coming = !mbc3_a_change_coming_a_l;
  always_comb a_change_coming_in = !a_change_coming_in_l;

  // The DRAM ("DISPATCH RAM" - not "DYNAMIC RAM") addressing
  // architecture in the KL10 is arse -- a bridge too far. Even the
  // microcode guys made fun of the choice as is evidenced by this quip
  // from the microcode listing:
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
  // 	0-4	;C-RAM BITS AS SPECIFIED UNDER "WCRAM"
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
    crobar_e_h = '1;
    repeat (100) @(negedge clk);
    crobar_e_h = '0;
  end

  initial begin
    dumpLogFD = $fopen("dump.log", "w");
  end

  always @(negedge crobar_e_h) begin
    repeat (10) @(negedge clk);
    KLMasterReset();

    KLSoftReset();
//    TestCRAM();
    KLLoadRAMs();
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
    W16 adr, count, cksum;
    W16 lastAdr = 0;

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
	adr = unASCIIize(words[1]);
	cksum = unASCIIize(words[2]);
	count = unASCIIize(words[3]);
	$display("CRAM zero adr=%07o cksum=%07o count=%d.", adr, cksum, count);
      end

      "C": begin		// CRAM record
	count = unASCIIize(words[0]);
	adr = unASCIIize(words[1]);

	if (count == 0 && adr == 0) begin
	  lastAdr = 0;
	end else begin
	  if (adr == 0) adr = lastAdr;
	  lastAdr = adr;
	  // $display("CRAM record count=%d lastAdr=%07o adr=%07o", count, lastAdr, adr);

	  for (int k = 2; k < count; ) begin
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
	    $fwrite(dumpLogFD, "C %04o: %030o\n", adr, cw);

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

	    writeCRAM(cw, tCRAMAddress'(adr));
	    ++adr;
	  end
	end
      end

      "D": begin		// DRAM record
	count = unASCIIize(words[0]);
	adr = unASCIIize(words[1]);

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
	    W36 even, odd, common;
	    bit [0:12] ir;
	    bit eParity, oParity;

	    even   = 36'(unASCIIize(words[k++]));
	    odd    = 36'(unASCIIize(words[k++]));
	    common = 36'(unASCIIize(words[k++]));

	    $fwrite(dumpLogFD, "D %03o: %05o %05o %05o\n", adr, even, odd, common);

	    // Set IR to address this DRAM location. 
	    // For non-I/O instructions just use adr[0:8] as IR[0:8].
	    if ((adr & 'o700) == 0)
	      ir = {k[0:8], 4'o0};
	    else begin
	      // For I/O instructions (where adr[0:2] == 7), spread
	      // the octal digits of the address across the 13 bits of
	      // opcode[0:2] and device[3:9] and operation[10:12].
	      //
	      // The middle digit, adr[3:5], selects the device
	      // (000-030 => 0..6) and 7 for all others, placed in
	      // ir[3:9].
	      //
	      // The least significant adr[6:8] digit selects the
	      // operation: BLKI=0, DATAI=1, BLKO=2, DATAO=3, CONO=4,
	      // CONI=5, CONSZ=6, CONSO=7, placed in ir[10:12].
	      ir[0:2] = k[0:2];
	      ir[3:9] = {4'o0, k[3:5]};
	      ir[10:12] = adr[6:8];
	    end

	    setDRAMDiagAddress(ir);

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

	    doDiagWrite(diagfLDRAM1, W36'(even) << 18);	  // DRAM A00-02, B00-02 even
	    doDiagWrite(diagfLDRAM2, W36'(odd) << 18);	  // DRAM A00-02, B00-02 odd
	    doDiagWrite(diagfLDRAM3, W36'(common) << 18); // J01-04

	    doDiagWrite(diagfLDRJEV, W36'(even) << 18);	  // J07-10 even
	    doDiagWrite(diagfLDRJOD, W36'(odd) << 18);	  // J07-10 odd

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

    $fclose(fd);
    $display("CRAM version: %s - as read back from CRAM", getCRAMVersionString());
    $fclose(dumpLogFD);
  endtask // KLLoadRAMs


  ////////////////////////////////////////////////////////////////
  // This loads the DRAM address to read or write with diagnostic
  // operations. Essentially it loads the address into IR[00:12] by
  // shoving it into AD[00:12] with `diagfLOAD_AR` and then using
  // `diagfIRLTCH` to load that into IR.
  task automatic setDRAMDiagAddress(input bit[0:12] a);
    doDiagWrite(diagfLOAD_AR, {a, 23'o0}); // Set address into AR[00:12] (opcode,AC fields)
    doDiagFunc(diagfIRLTCH);	      // Unlatch IR and load it from AD to address DRAM
  endtask // setDRAMDiagAddress


  ////////////////////////////////////////////////////////////////
  // Set the address to diagnostic read or write CRA and CRM.
  task automatic setCRAMDiagAddress(tCRAMAddress addr);
    doDiagWrite(diagfCRAM_DIAG_ADR_RH, {addr[05:10], 30'o0}); // CRAM address[05:10]
    doDiagWrite(diagfCRAM_DIAG_ADR_LH, {1'o0, addr[00:04], 30'o0}); // CRAM address[00:04]
  endtask // setCRAMDiagAddress


  task automatic waitEBOX();
    repeat(20) @(negedge clk) ;
  endtask
  

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
`define putCRM(bitN, slot, a10Chip, notA10Chip)		\
    if (adr[10] == 0) begin				\
      kl10pv.slot.notA10Chip.ram[adr[0:9]] = cw[bitN];	\
    end else begin					\
      kl10pv.slot.a10Chip.ram[adr[0:9]] = cw[bitN];	\
    end

  task automatic writeCRAM(tCRAM cw, tCRAMAddress adr);
    `putCRM(0, 	crm_52, e59, e57)
    `putCRM(1, 	crm_52, e48, e44)
    `putCRM(2, 	crm_52,  e4,  e2)
    `putCRM(3, 	crm_52, e17, e14)

    `putCRM(4, 	crm_50, e59, e57)
    `putCRM(5, 	crm_50, e48, e44)
    `putCRM(6, 	crm_50,  e4,  e2)
    `putCRM(7, 	crm_50, e17, e14)

    `putCRM(8, 	crm_44, e59, e57)
    `putCRM(9, 	crm_44, e48, e44)
    `putCRM(10, crm_44,  e4,  e2)
    `putCRM(11, crm_44, e17, e14)

    `putCRM(12, crm_42, e59, e57)
    `putCRM(13, crm_42, e48, e44)
    `putCRM(14, crm_42,  e4,  e2)
    `putCRM(15, crm_42, e17, e14)

    `putCRM(16, crm_40, e59, e57)
    `putCRM(17, crm_40, e48, e44)
    `putCRM(18, crm_40,  e4,  e2)
    `putCRM(19, crm_40, e17, e14)


    `putCRM(20, crm_52, e55, e51)
    `putCRM(21, crm_52, e41, e37)
    `putCRM(22, crm_52, e10,  e7)
    `putCRM(23, crm_52, e24, e21)

    `putCRM(24, crm_50, e55, e51)
    `putCRM(25, crm_50, e41, e37)
    `putCRM(26, crm_50, e10,  e7)
    `putCRM(27, crm_50, e24, e21)

    `putCRM(28, crm_44, e55, e51)
    `putCRM(29, crm_44, e41, e37)
    `putCRM(30, crm_44, e10,  e7)
    `putCRM(31, crm_44, e24, e21)

    `putCRM(32, crm_42, e55, e51)
    `putCRM(33, crm_42, e41, e37)
    `putCRM(34, crm_42, e10,  e7)
    `putCRM(35, crm_42, e24, e21)

    `putCRM(36, crm_40, e55, e51)
    `putCRM(37, crm_40, e41, e37)
    `putCRM(38, crm_40, e10,  e7)
    `putCRM(39, crm_40, e24, e21)


    `putCRM(40, crm_52, e56, e52)
    `putCRM(41, crm_52, e42, e38)
    `putCRM(42, crm_52, e11,  e8)
    `putCRM(43, crm_52, e25, e22)

    `putCRM(44, crm_50, e56, e52)
    `putCRM(45, crm_50, e42, e38)
    `putCRM(46, crm_50, e11,  e8)
    `putCRM(47, crm_50, e25, e22)

    `putCRM(48, crm_44, e56, e52)
    `putCRM(49, crm_44, e42, e38)
    `putCRM(50, crm_44, e11,  e8)
    `putCRM(51, crm_44, e25, e22)

    `putCRM(52, crm_42, e56, e52)
    `putCRM(53, crm_42, e42, e38)
    `putCRM(54, crm_42, e11,  e8)
    `putCRM(55, crm_42, e25, e22)

    `putCRM(56, crm_40, e56, e52)
    `putCRM(57, crm_40, e42, e38)
    `putCRM(58, crm_40, e11,  e8)
    `putCRM(59, crm_40, e25, e22)


    `putCRM(60, crm_52, e49, e45)
    `putCRM(62, crm_52, e18, e15)

    `putCRM(64, crm_50, e49, e45)
    `putCRM(66, crm_50, e18, e15)

    `putCRM(68, crm_44, e49, e45)
    `putCRM(70, crm_44, e18, e15)

    `putCRM(72, crm_42, e49, e45)
    `putCRM(74, crm_42, e18, e15)

    `putCRM(76, crm_40, e49, e45)
    `putCRM(78, crm_40, e18, e15)

    // CRA for the last six bits
    `putCRM(80, cra_45,  e9,  e4)
    `putCRM(81, cra_45, e29, e24)
    `putCRM(82, cra_45, e14, e19)
    `putCRM(83, cra_45, e25, e30)
    `putCRM(84, cra_45, e10,  e5)
    `putCRM(85, cra_45, e15, e20)
  endtask // writeCRAM


  // From `klinit.l20` routine `RDMCV`:
  // MAJOR VERSION IS IN BITS 29-31 33-35 OF CRAM ADDRESS 136
  // SUB-VERSION IS IN BITS 37-39 OF CRAM ADDRESS 136
  // EDIT LEVEL IS IN BITS 29-31 33-35 37-39 OF CRAM ADDRESS 137
  function automatic string getCRAMVersionString();
    bit [0:5] 	majver;
    bit [0:2] 	minver;
    bit [0:8] 	edit;
    string 	majS, minS, editS;

    setCRAMDiagAddress('o136);
    readCRAM();
    majver = {cw[29:31], cw[33:35]};
    minver = cw[37:39];
    $display("136: cw=%o majver=%o minver=%o", cw, majver, minver);

    setCRAMDiagAddress('o137);
    readCRAM();
    edit = {cw[29:31], cw[33:35], cw[37:39]};
    $display("137: cw=%o edit=%o", cw, edit);

    majS.octtoa(majver);
    minS.octtoa(minver);
    editS.octtoa(edit);

    return {majS, ".", minS, "(", editS, ")"};
  endfunction // getCRAMVersion


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
