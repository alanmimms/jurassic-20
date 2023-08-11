`include "ebox.svh"

module kl10pv_tb(iAPR APR,
                 iCCL CCL,
                 iCCW CCW,
                 iCHA CHA,
                 iCHC CHC,
                 iCLK CLK,
                 iCON CON,
                 iCRA CRA,
                 iCRAM CRAM,
                 iCRC CRC,
                 iCRM CRM,
                 iCSH CSH,
                 iCTL CTL,
                 iEDP EDP,
                 iIR IR,
                 iMBC MBC,
                 iMBX MBX,
                 iMBZ MBZ,
                 iMCL MCL,
                 iMTR MTR,
                 iPAG PAG,
                 iPI PIC,
                 iPMA PMA,
                 iSCD SCD,
                 iSHM SHM,
                 iVMA VMA,

                 iEBUS.dte EBUS,
                 iMBOX MBOX,
                 input bit [18:35] hwOptions,

                 output bit CROBAR,
                 output bit clk,
                 output bit clk30,
                 output bit clk31,
                 output bit EXTERNAL_CLK,

                 output bit PWR_WARN
                 );
  bit masterClk;

  var string indent = "";
  var int nSteps;

  tEBUSdriver EBUSdriver;       // The DTE drives the EBUS too

  assign clk = masterClk;
  assign EXTERNAL_CLK = masterClk;
  assign clk30 = masterClk;
  assign clk31 = masterClk;     // XXX for now

  // 62MHz clock source
  initial masterClk <= 0;
  always #(1000.0/31.0/2.0) masterClk = ~masterClk; // 31MHz master clock

  initial $readmemh("../images/DRAM.mem", ebox0.ir0.dram.mem);
  initial $readmemh("../images/CRAM.mem", ebox0.crm0.cram.mem);

  initial begin
    // Initialize our memories
    // Based on KLINIT.L20 $ZERAC subroutine.
    // Zero all ACs, including the ones in block #7 (microcode's ACs).
    // For now, MBOX memory is zero too.
    for (int a = 0; a < $size(ebox0.edp0.fm.mem); ++a) ebox0.edp0.fm.mem[a] <= '0;
    for (int a = 0; a < $size(memory0.mem); ++a) memory0.mem[a] <= '0;

    CON.CONO_200000 <= 0;
  end

  tCRAM cram137;
  initial begin
    #10 CROBAR <= 1;     // CROBAR stays asserted for a long time
    #1000 CROBAR <= 0;   // 1us CROBAR for the 21st century (and sims)

    #100 KLMasterReset();

    // Suck out field from microcode in well known address to retrieve
    // microcode edit number.
    cram137 <= ebox0.crm0.cram.mem['o137];
    #100 KLBootDialog(cram137.MAGIC[0:8], hwOptions);
  end


  // Functions from KLINIT.L20 $KLMR (DO A MASTER RESET ON THE KL)
  task KLMasterReset;
    $display($time, " KLMasterReset() START");
    indent = "  ";

    // $DFXC(.CLRUN=010)    ; Clear run
    doDiagFunc(diagfCLR_RUN);

    // This is the first phase of DMRMRT table operations.
    doDiagWrite(diagfCLR_CLK_SRC_RATE, '0);           // CLOCK LOAD FUNC #44
    doDiagFunc(diagfSTOP_CLOCK);                      // STOP THE CLOCK
    doDiagFunc(diagfSET_RESET);                       // SET RESET
    doDiagWrite(diagfRESET_PAR_REGS, '0);             // LOAD CLK PARITY CHECK & FS CHECK
    doDiagWrite(diagfCLR_MBOXDIS_PARCHK_ERRSTOP, '0); // LOAD CLK MBOX CYCLE DISABLES,
    // PARITY CHECK, ERROR STOP ENABLE
    doDiagWrite(diagfCLR_BURST_CTR_RH, '0);           // LOAD BURST COUNTER (8,4,2,1)
    doDiagWrite(diagfCLR_BURST_CTR_LH, '0);           // LOAD BURST COUNTER (128,64,32,16)
    doDiagWrite(diagfSET_EBOX_CLK_DISABLES, '0);      // LOAD EBOX CLOCK DISABLE
    doDiagFunc(diagfSTART_CLOCK);                     // START THE CLOCK
    doDiagWrite(diagfINIT_CHANNELS, '0);              // INIT CHANNELS
    doDiagWrite(diagfCLR_BURST_CTR_RH, '0);           // LOAD BURST COUNTER (8,4,2,1)

    // Loop up to three times:
    //   Do diag function 162 via $DFRD test (A CHANGE COMING A L)=EBUS[32]
    //   If not set, $DFXC(.SSCLK=002) to single step the MBOX
    $display($time, " [step up to 5 clocks to syncronize MBOX]");
    repeat (5) begin
      #500 ;
      if (!mbox0.mbc0.MBC.A_CHANGE_COMING) break;
      #500 ;
      doDiagFunc(diagfSTEP_CLOCK);
    end

    if (mbox0.mbc0.MBC.A_CHANGE_COMING) begin
      $display($time, " ERROR: STEP of MBOX five times did not clear MBC.A_CHANGE_COMING");
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
  task KLBootDialog(input int microcodeEditNumber, input bit [0:35] hwo);
    // Time to pretend a little...
    $display("");
    $display("KLISIM -- VERSION 0.0.1 RUNNING");
    $display("KLISIM -- KL10 S/N: %0d., MODEL B, %0d HERTZ",
             hwo[23:35], hwo[18] ? 50 : 60);
    $display("KLISIM -- KL10 HARDWARE ENVIRONMENT");
    if (hwo[22]) $display("   MOS MASTER OSCILLATOR");
    if (hwo[21]) $display("   EXTENDED ADDRESSING");
    if (hwo[20]) $display("   INTERNAL CHANNELS");
    if (hwo[19]) $display("   CACHE");
    $display("");
    $display("KLISIM -- MICROCODE VERSION %0o LOADED", microcodeEditNumber);
    $display("");

    $display($time, " KLBootDialog() START");
    indent = "  ";
    // XXX TODO

    // Functions from KLINIT.L20 $DLGEN (ASK IF ENTERING DIALOG IS REQUIRED)
    // (starting at 71:)
    // HLTNOE   ; Halt the KL and disable -20F interruptions
    //   ..DTSP ; Turn off 20F interrupts and turn off protocols
    //   $DFXC(.CLRUN)  ; Halt the KL if running
    // LQSCSW   ; Sweep the cache
    //   do BLKO CCA,0  ; Sweep each cache block
    //   $DFXC(.CONBT)  ; Push the CONTINUE button
    //   $DFXC(.STRCL)  ; Start KL clocks
    // LQSHDW   ; Determine the hardware features of the KL
    //   LQSHWO ; Get RH(APRID) through a very sick hack
    // LQSCHO   ; Make sure no conflicting HW options (not needed here)

    // fall through into $CFGBT
    // Test for presence of cache and configure it.

    // Functions from KLINIT.L20 $EXBLD (LOAD THE BOOT) routine
    loadBootstrap();

    // Sweep the cache
    // XXX TBD

    // Turn off the NXM bit (FE uses CONO APR,,22000).
    MBOX.NXM_ERR <= 0;

    ////////////////////////////////////////////////////////////////
    // Falls through into LXBRC 10$ symbol for end of boot loader
    // file, check for NXM during load, then if all goes well enters
    // $TENST as shown below.
    //
    // Functions from KLINIT.L20 $TENST (START KL BOOT) routine
    // This was done earlier. XXX probably needs to be done again on reset.
    //    for (int a = 0; a < $size(ebox0.edp0.fm.mem); ++a) ebox0.edp0.fm.mem[a] = '0;

    // Execute equivalent of a series of CONO/DATAO instructions to do
    // the following operations.

    ////////////
    // CONO APR,267760                  ; Reset APR and I/O
    begin
      // Clear all IO devices
      // XXX NOTE THIS IS NOT DOING ANYTHING RIGHT NOW

      // Clear/disable selected flags
      // SBUS error, NXM, IO page fail
      MBOX.SBUS_ERR <= 0;
      ebox0.apr0.SBUS_ERR_EN <= 0;
      MBOX.NXM_ERR <= 0;
      ebox0.apr0.NXM_ERR_EN <= 0;
      APR.SET_IO_PF_ERR <= 0;
      ebox0.apr0.IO_PF_ERR_EN <= 0;

      // MB parity, cache dir, addr parity
      MBOX.MB_PAR_ERR <= 0;
      ebox0.apr0.MB_PAR_ERR_EN <= 0;
      MBOX.CSH_ADR_PAR_ERR <= 0;
      ebox0.apr0.C_DIR_P_ERR_EN <= 0;
      ebox0.apr0.MBOX.MBOX_ADR_PAR_ERR <= 0;
      ebox0.apr0.S_ADR_P_ERR_EN <= 0;

      // power fail, sweep done
      PWR_WARN <= 0;
      ebox0.apr0.PWR_FAIL <= 0;
      APR.SWEEP_BUSY <= 0;
      ebox0.apr0.SWEEP_DONE_EN <= 0;

      // PI interrupt level #0
      ebox0.pi0.PIC.APR_PIA <= 0;
    end

    ////////////
    // CONO PI,10000            ; Reset PI
    begin
      ebox0.pi0.ON <= 0;
      ebox0.pi0.GEN <= 0;
      ebox0.pi0.PIR_EN <= 0;
      ebox0.pi0.PI_REQ_SET <= 0;
      ebox0.pi0.PIH <= 0;
      ebox0.pi0.ACTIVE <= 0;
    end

    ////////////
    // CONO PAG, 0              ; Paging system clear
    begin
      CON.CACHE_LOOK_EN <= 0;
      CON.CACHE_LOAD_EN <= 0;
      ebox0.con0.WR_EVEN_PAR_DATA <= 0;
      ebox0.con0.WR_EVEN_PAR_DIR <= 0;
    end

    ////////////
    // DATAO PAG, 0             ; User base clear
    begin
      // Set current and previous AC blocks to zero.
      APR.CURRENT_BLOCK <= '0;
      APR.PREV_BLOCK <= '0;
      APR.CURRENT_BLOCK <= '0;
      APR.CURRENT_BLOCK <= '0;

      // Set current section context to zero.
      // XXX Not 100% certain this is what this is supposed to do.
      VMA.PREV_SEC <= '0;

      // Load UPT page number with zero.
      // XXX Not 100% certain this is what this is supposed to do.
      mbox0.pma0.UBR <= '0;

      // Invalidate the entire page table by setting the invalid bits in all lines.
      /*      Sim already does this by initializing entire RAM to zeros.
       for (int a = 0; a < $size(mbox0.pag0.ptDirA); ++a) begin
       mbox0.pag0.ptDirA[a] <= '0;
       mbox0.pag0.ptDirB[a] <= '0;
       mbox0.pag0.ptDirC[a] <= '0;
       mbox0.pag0.ptParity[a] <= '0;
       end
       */
      // XXX For now, we do not turn on the cache. Here is where it
      // should be enabled if we want it.
      // Set $SETCA (CONFIGURE CACHE) routine in KLINIT.L20 for details on how.
    end

    //////////////////
    // Here is where FE looks at .KLISV to detrmine which bits AC0 should get:
    // - 1b0 for no boot prompting
    // - 1b1 for dump KL

    // (047) Load clock MBOX cycle disables, parity check, error stop enable (.LDCK2)
    // FE loads 3 and calls .LDCK2
    doDiagWrite(diagfCLR_MBOXDIS_PARCHK_ERRSTOP, 4'b0011);

    // (046) Load clock parity check and FS check (.LDCK1)
    // FE loads 0o16 (#FM!CM!DM) and calls .LDCK1
    doDiagWrite(diagfRESET_PAR_REGS, 4'b1110);

    // Start clocks (.STRCL=001)
    doDiagFunc(diagfSTART_CLOCK);

    //////////////////////////////////////////////////////////////////
    // Functions from $STRKL (START THE KL PROCESSOR)
    //
    // THIS IS DONE BY LOADING THE AR WITH THE ADDRESS, PUSHING
    // THE RUN AND CONTINUE BUTTONS, AND STARTING THE CLOCK.
    // WE STEP THE MICROCODE OUT OF THE HALT LOOP TO MAKE SURE IT
    // IS RUNNING BEFORE WE LEAVE.
    //
    // Boot address is hardcoded to 40000 for now.
    EDP.AR <= 'o40000;
    $display($time, " [AR set to boot address %s]", octW(EDP.AR));

    // Set the RUN flop.
    doDiagFunc(diagfSET_RUN);

    repeat (10) @(negedge CLK.MHZ16_FREE) ; // Wait for RUN flop to get clocked in

    if (!CON.RUN) begin
      $display($time, " ???ERROR: diagfSET_RUN should set the RUN flop and it didn't");
    end

    // Wait for HALT loop
    $display($time, " [step up to 1000 clocks to get KL to HALT loop] halted=%b",
             CON.EBOX_HALTED);
    for (nSteps = 0; nSteps < 1000; ++nSteps) begin
      doDiagFunc(diagfSTEP_CLOCK);
      if (CON.EBOX_HALTED) break;
    end

    if (nSteps == 1000)
      $display($time, " ???ERROR: wait to enter HALT loop didn't succeed");
    else
      $display($time, " [it took %0d steps to get to HALT loop]", nSteps);

    // Set the CONTINUE button.
    doDiagFunc(diagfCONTINUE);

    // Single step the MBOX clock up to 1000 times waiting for
    // microcode to exit from the HALT loop.
    $display($time, " [step up to 1000 clocks to get KL out of HALT loop] halted=%b",
             CON.EBOX_HALTED);

    for (nSteps = 0; nSteps < 1000; ++nSteps) begin
      doDiagFunc(diagfSTEP_CLOCK);
      if (!CON.EBOX_HALTED) break;
    end

    if (CON.EBOX_HALTED) begin
      $display($time, " ???ERROR: STEP MBOX <1000 times waiting for HALT loop didn't clear CON.EBOX_HALTED");
    end

    // Verify RUN flop is still set.
    if (!CON.RUN) begin
      $display($time, " ???ERROR: STEP MBOX <1000 times waiting for HALT loop cleared the RUN flop???");
    end

    $display($time, " [it took %0d steps to get out of HALT loop]", nSteps);

    // Start the clock.
    $display($time, " [starting with AR=%s]", octW(EDP.AR));
    doDiagFunc(diagfSTART_CLOCK);

    $display($time, " DONE");
    indent = "";
  endtask


  typedef bit [7:0] tFileWord[0:4];


  function bit [0:35] fileWordToWord(input tFileWord fw);
    fileWordToWord = (fw[0] << 28) |
                     (fw[1] << 20) |
                     (fw[2] << 12) |
                     (fw[3] <<  4) |
                     (fw[4] >>  4);
  endfunction


  // Load the BOOT.EXE bootstrap into our fake memory
  function void loadBootstrap();
    automatic int fd;
    automatic int nRead;
    automatic tFileWord iowd;
    automatic bit [0:35] w;
    automatic bit [0:35] minAddr;
    automatic bit [0:35] maxAddr;
    automatic bit [0:17] nww;
    automatic bit [0:17] addr;
    automatic int nWords;

    $display("");
    $display("[Loading BOOT.EXE]");

    minAddr = 36'o777777_777777;
    maxAddr = '0;

    fd = $fopen("../images/boot/boot.exe", "rb");

    while (1) begin
      nRead = $fread(iowd, fd);
      w = fileWordToWord(iowd);
      nww = w[0:17];
      addr = w[18:35];

      if (nww < 18'o400000) begin
        break;
      end else begin
        nWords = 19'o1000000 - nww;
        //        $display("%06o: %0d words", addr, nWords);

        for (int nw = nWords; nw; --nw) begin
          nRead = $fread(iowd, fd);
          w = fileWordToWord(iowd);
          memory0.mem[addr] = w;

          if (addr < minAddr) minAddr = addr;
          if (addr > maxAddr) maxAddr = addr;
          ++addr;
        end
      end
    end

    $display("[loaded]");
    $display("[start instruction is %s]", octW(w));
    $display("[start instruction also put in mem[0]]");
    memory0.mem[0] = w;
    $display("[boot image minAddr: %06o]", minAddr);
    $display("[boot image maxAddr: %06o]", maxAddr);
    $display("");
  endfunction


  function string octW(input bit [0:35] w);
    $sformat(octW, "%06o,,%06o", w[0:17], w[18:35]);
  endfunction


  ////////////////////////////////////////////////////////////////
  // Request the specified CLK diagnostic function as if we were the
  // front-end setting up a KL10pv.
  task doDiagFunc(input tDiagFunction func);

    @(negedge CLK.MHZ16_FREE) begin
      string shortName;
      shortName = replace(func.name, "diagf", "");
      EBUS.ds <= func;
      EBUS.diagStrobe <= 1;            // Strobe this
      if (func !== diagfSTEP_CLOCK) $display($time, " %sASSERT ds=%s", indent, shortName);
    end

    repeat (8) @(negedge CLK.MHZ16_FREE) ;

    @(negedge CLK.MHZ16_FREE) begin
      string shortName;
      shortName = replace(func.name, "diagf", "");
      EBUS.ds <= diagfIdle;
      EBUS.diagStrobe <= 0;
      if (func !== diagfSTEP_CLOCK) $display($time, " %sDEASSERT ds=%s", indent, shortName);
    end

    repeat(4) @(posedge CLK.MHZ16_FREE) ;
  endtask


  ////////////////////////////////////////////////////////////////
  // Request the specified CLK diagnostic function as if we were the
  // front-end setting up a KL10pv.
  task doDiagWrite(input tDiagFunction func, input bit [18:35] ebusRH);

    @(negedge CLK.MHZ16_FREE) begin
      string shortName;
      shortName = replace(func.name, "diagf", "");
      EBUSdriver.data[18:35] = ebusRH;
      EBUS.ds <= func;
      EBUS.diagStrobe <= 1;            // Strobe this
      EBUSdriver.driving <= 1;
      $display($time, " %sASSERT ds=%s [EBUS.data.rh=%06o]", indent, shortName, ebusRH);
    end

    repeat (8) @(negedge CLK.MHZ16_FREE) ;

    @(negedge CLK.MHZ16_FREE) begin
      string shortName;
      shortName = replace(func.name, "diagf", "");
      EBUS.ds <= diagfIdle;
      EBUS.diagStrobe <= 0;
      EBUSdriver.driving <= 0;
      $display($time, " %sDEASSERT ds=%s", indent, shortName);
    end

    repeat(4) @(posedge CLK.MHZ16_FREE) ;
  endtask


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

endmodule
