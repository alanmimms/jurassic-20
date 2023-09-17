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

  bit [20:39] cram136;
  bit [20:39] cram137;

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
  // 	EVEN	;D-RAM EVEN BITS AS SPECIFIES UNDER "WDRAM"
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

    // Debugging sentinel
    doDiagFunc(diagfCLR_RUN);
    TestCRAM();
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
    bit [0:85] cw;

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
	    cw[64:79] = 16'(unASCIIize(words[k++]));
	    cw[48:63] = 16'(unASCIIize(words[k++]));
	    cw[32:47] = 16'(unASCIIize(words[k++]));
	    cw[16:31] = 16'(unASCIIize(words[k++]));
	    cw[00:15] = 16'(unASCIIize(words[k++]));
	    cw[80:85] =  6'(unASCIIize(words[k++]));
	    $fwrite(dumpLogFD, "%04o: %030o\n", adr, cw);
	    writeCRAM(11'(adr), cw);
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
	  if (adr == 0) adr = lastAdr;
	  lastAdr = adr + count;
	  //	    $display("DRAM record count=%d lastAdr=%07o adr=%07o", count, lastAdr, adr);
	end
      end

      ";": ;			// Comment - ignore

      default:
	$display("ERROR: Unknown record type '%s' in KLX.RAM file", recType);
      endcase
    end

    $fclose(fd);
    $display("CRAM version: %s", getCRAMVersionString());
  endtask // KLLoadRAMs


  ////////////////////////////////////////////////////////////////
  task automatic TestCRAM;
    bit doOneHotCRAM80_85 = 1;
    bit doOneHotCRAMAll = 0;

    $display($time, " TestCRAM() START");
    doDiagFunc(diagfSTART_CLOCK); // START THE CLOCK.

    // We have to write the AR register so its parity is correct to
    // avoid getting wrongheaded parity errors.
    doDiagWrite(diagfLOAD_AR, '0);

    // Just write one-hot bit values to CRAM[80:85] at address=000 in
    // succession, reading each back.
    if (doOneHotCRAM80_85) begin
      W36 readResult;

      // Set zero as CRAM address to write.
      doDiagWrite(diagfCRAM_DIAG_ADR_RH, 36'o0); // CRAM address[05:10]
      doDiagWrite(diagfCRAM_DIAG_ADR_LH, 36'o0); // CRAM address[00:04]

      doDiagWrite(diagfCRAM_WRITE_80_85, 36'o1 << 35);
      doDiagWrite(diagfLOAD_AR, 36'o123456654321); // Change EBUS data lines
      doDiagRead(diagfCRAM_READ_80_85, readResult);

      doDiagWrite(diagfCRAM_WRITE_80_85, 36'o1 << 34);
      doDiagWrite(diagfLOAD_AR, 36'o123456654321); // Change EBUS data lines
      doDiagRead(diagfCRAM_READ_80_85, readResult);

      doDiagWrite(diagfCRAM_WRITE_80_85, 36'o1 << 33);
      doDiagWrite(diagfLOAD_AR, 36'o123456654321); // Change EBUS data lines
      doDiagRead(diagfCRAM_READ_80_85, readResult);

      doDiagWrite(diagfCRAM_WRITE_80_85, 36'o1 << 32);
      doDiagWrite(diagfLOAD_AR, 36'o123456654321); // Change EBUS data lines
      doDiagRead(diagfCRAM_READ_80_85, readResult);

      doDiagWrite(diagfCRAM_WRITE_80_85, 36'o1 << 31);
      doDiagWrite(diagfLOAD_AR, 36'o123456654321); // Change EBUS data lines
      doDiagRead(diagfCRAM_READ_80_85, readResult);

      doDiagWrite(diagfCRAM_WRITE_80_85, 36'o1 << 30);
      doDiagWrite(diagfLOAD_AR, 36'o123456654321); // Change EBUS data lines
      doDiagRead(diagfCRAM_READ_80_85, readResult);
    end

    doDiagWrite(diagfLOAD_AR, 36'o123456654321); // Change EBUS data lines

    // For now, just load and read back one-hot walking bit pattern
    // into CRAM to debug write and read.
    $display("[Load walking one-hot bit pattern into CRAM for testing]");
    for (bit [0:10] a = 0; doOneHotCRAMAll && a < 86; ++a) begin
      W36 readResult;
      bit [0:85] cw;

      cw[0:85] = '0;
      cw[a] = '1;
      writeCRAM(a, cw);

      doDiagRead(diagfCRAM_READ_00_19, readResult);
      cw[00:19] = readResult[00:19];
      doDiagRead(diagfCRAM_READ_20_39, readResult);
      cw[20:39] = readResult[00:19];
      doDiagRead(diagfCRAM_READ_40_59, readResult);
      cw[40:59] = readResult[00:19];
      doDiagRead(diagfCRAM_READ_60_79, readResult);
      cw[60:79] = readResult[00:19];
      doDiagRead(diagfCRAM_READ_80_85, readResult);
      cw[80:85] = readResult[00:05];
    end

    $display($time, " TestCRAM() END");
  endtask // TestCRAM


  ////////////////////////////////////////////////////////////////
  // Write specified CRAM word to specified CRAM address.  Composed
  // while looking at klinit.l20 $WCRAM and various other sources..
  // 
  // CRM4 is PDF395. See decoder E1 on PDF393 for diag func decode and
  // corresponding bits.
  //
  // CRA5 is PDF347. This for the CALL+DISP[0:5] bits.
  task automatic writeCRAM(input bit [0:10] addr, input bit[0:85] cw);
    //    $display($time, " writeCRAM addr=%04o  cw=%029o", addr, cw);
    doDiagWrite(diagfCRAM_DIAG_ADR_RH, {addr[05:10], 30'o0}); // CRAM address[05:10]
    doDiagWrite(diagfCRAM_DIAG_ADR_LH, {1'o0, addr[00:04], 30'o0}); // CRAM address[00:04]
    doDiagWrite(diagfCRAM_WRITE_60_79, {8'o0,
					cw[60], 1'o0, cw[62], 3'o0, cw[64], 1'o0,
					cw[66], 3'o0, cw[68], 1'o0, cw[70], 3'o0,
					cw[72], 1'o0, cw[74], 3'o0, cw[76], 1'o0,
					cw[78], 1'o0});  // CRM4,5
    doDiagWrite(diagfCRAM_WRITE_40_59, {8'o0,
					cw[40:43], 2'o0, cw[44:47], 2'o0,
					cw[48:51], 2'o0, cw[52:55], 2'o0,
					cw[56:59]});  // CRM4,5
    doDiagWrite(diagfCRAM_WRITE_20_39, {8'o0,
					cw[20:23], 2'o0, cw[24:27], 2'o0,
					cw[28:31], 2'o0, cw[32:35], 2'o0,
					cw[36:39]});  // CRM4,5
    doDiagWrite(diagfCRAM_WRITE_00_19, {8'o0,
					cw[00:03], 2'o0, cw[04:07], 2'o0,
					cw[08:11], 2'o0, cw[12:15], 2'o0,
					cw[16:19]});  // CRM4,5
    doDiagWrite(diagfCRAM_WRITE_80_85, {cw[80:85], 30'o0}); // CRA5   CRAM[80:85] <- EBUS[0:5]

    if (addr == 11'o136) begin
      cram136 = cw[20:39];
    end else if (addr == 11'o137) begin
      bit [0:5] 	majver;
      bit [0:2] 	minver;
      bit [0:8] 	edit;

      cram137 = cw[20:39];

      majver = {cram136[29:31], cram136[33:35]};
      minver = cram136[37:39];
      edit = {cram137[29:31], cram137[33:35], cram137[37:39]};
      $display("CRAM version: %o.%02o(%o)", majver, minver, edit);
    end
  endtask // writeCRAM


  // From `klinit.l20` routine `RDMCV`:
  // MAJOR VERSION IS IN BITS 29-31 33-35 OF CRAM ADDRESS 136
  // SUB-VERSION IS IN BITS 37-39 OF CRAM ADDRESS 136
  // EDIT LEVEL IS IN BITS 29-31 33-35 37-39 OF CRAM ADDRESS 137
  function automatic string getCRAMVersionString();
    W36 readResult;
    bit [20:39] cwBits;
    bit [0:5] 	majver;
    bit [0:2] 	minver;
    bit [0:8] 	edit;
    string 	majS, minS, editS;

    doDiagWrite(diagfCRAM_DIAG_ADR_RH, 36'o36 << 30);
    doDiagWrite(diagfCRAM_DIAG_ADR_LH, 36'o01 << 30);
    doDiagRead(diagfCRAM_READ_20_39, readResult);
    cwBits = readResult[00:19];
    majver = {cwBits[29:31], cwBits[33:35]};
    minver = cwBits[37:39];
    $display("136: readResult=%0o cwBits=%07o majver=%o minver=%o",
	     readResult, cwBits, majver, minver);

    doDiagWrite(diagfCRAM_DIAG_ADR_RH, 36'o37 << 30);
    doDiagWrite(diagfCRAM_DIAG_ADR_LH, 36'o01 << 30);
    doDiagRead(diagfCRAM_READ_20_39, readResult);
    cwBits = readResult[00:19];
    edit = {cwBits[29:31], cwBits[33:35], cwBits[37:39]};
    $display("137: readResult=%0o cwBits=%0o edit=%o", readResult, cwBits, edit);

    majS.octtoa(majver);
    minS.octtoa(minver);
    editS.octtoa(edit);

    return {majS, ".", minS, "(", editS, ")"};
  endfunction // getCRAMVersion
  

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

    @(negedge clk) ;
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
      int ch = int'(s[k]);
      v = v | (W16'(ch >= 'o100 && ch <= 32'o175 ? (ch & ~'o100) : ch)) << shift;
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
