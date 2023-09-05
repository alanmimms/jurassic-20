// Simulate the front end functions we need to test the KL10-PV.

`include "kl10pv.svh"
`include "dte.svh"


// Here `clk` is the `CLK 10/11 CLK H` from the CLK module PDF169.
module fe_sim(input bit clk,
	      iEBUS ebus,
	      output tEBUSdriver EBUSdriver,
	      input mbc3_a_change_coming_a_l,
	      input a_change_coming_in_l,
	      output bit crobar_e_h,
	      output bit con_cono_200000_h);

  var string indent = "";

  bit a_change_coming, a_change_coming_in;
  always_comb a_change_coming = !mbc3_a_change_coming_a_l;
  always_comb a_change_coming_in = !a_change_coming_in_l;

  initial begin
    con_cono_200000_h = '0;
  end

  initial begin
    crobar_e_h <= '1;
    #1000 crobar_e_h <= '0;

    #100 KLMasterReset();
  end


  ////////////////////////////////////////////////////////////////
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
      if (!a_change_coming) break;
      #500 ;
      doDiagFunc(diagfSTEP_CLOCK);
    end

    if (a_change_coming) begin
      $display($time, " ERROR: STEP of MBOX five times did not clear a_change_coming");
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
  // Write the specified CLK module diagnostic function with data on
  // ebusRH as if we were the front-end setting up a KL10-PV.
  task doDiagWrite(input tDiagFunction func, input bit [18:35] ebusRH);

    @(negedge clk) begin
      string shortName;
      shortName = replace(func.name, "diagf", "");
      EBUSdriver.data[18:35] = ebusRH;
      ebus.ds <= func;
      ebus.diagStrobe <= 1;            // Strobe this
      EBUSdriver.driving <= 1;
      $display($time, " %sASSERT ds=%s [EBUS.data.rh=%06o]", indent, shortName, ebusRH);
    end

    repeat (8) @(negedge clk) ;

    @(negedge clk) begin
      string shortName;
      shortName = replace(func.name, "diagf", "");
      ebus.ds <= diagfIdle;
      ebus.diagStrobe <= 0;
      EBUSdriver.driving <= 0;
      $display($time, " %sDEASSERT ds=%s", indent, shortName);
    end

    repeat(4) @(posedge clk) ;
  endtask


  ////////////////////////////////////////////////////////////////
  // Request the specified CLK module diagnostic function as if we
  // were the front-end setting up a KL10pv.
  task doDiagFunc(input tDiagFunction func);

    @(negedge clk) begin
      string shortName;
      shortName = replace(func.name, "diagf", "");
      ebus.ds <= func;
      ebus.diagStrobe <= 1;            // Strobe this
      if (func !== diagfSTEP_CLOCK) $display($time, " %sASSERT ds=%s", indent, shortName);
    end

    repeat (8) @(negedge clk) ;

    @(negedge clk) begin
      string shortName;
      shortName = replace(func.name, "diagf", "");
      ebus.ds <= diagfIdle;
      ebus.diagStrobe <= 0;
      if (func !== diagfSTEP_CLOCK) $display($time, " %sDEASSERT ds=%s", indent, shortName);
    end

    repeat(4) @(posedge clk) ;
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


endmodule; // fe_sim
