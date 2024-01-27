`include "kl10pv.svh"

// The top of the hierarchy for KL10PV CPU and its front end, memory,
// peripherals, and power system.
module kl10pv(input top_clk);

  tEBUSdriver aprEBUSdriver, cclEBUSdriver, ccwEBUSdriver, chcEBUSdriver;
  tEBUSdriver clkEBUSdriver, conEBUSdriver, craEBUSdriver, crcEBUSdriver;
  tEBUSdriver crm40EBUSdriver, crm42EBUSdriver, crm44EBUSdriver, crm50EBUSdriver, crm52EBUSdriver;
  tEBUSdriver cshEBUSdriver, ctlEBUSdriver, chxEBUSdriver;
  tEBUSdriver edp39EBUSdriver, edp41EBUSdriver, edp43EBUSdriver,
	      edp49EBUSdriver, edp51EBUSdriver, edp53EBUSdriver;
  tEBUSdriver irdEBUSdriver, mbcEBUSdriver, mbxEBUSdriver;
  tEBUSdriver mbzEBUSdriver, mclEBUSdriver, mtrEBUSdriver, picEBUSdriver, scdEBUSdriver;
  tEBUSdriver vmaEBUSdriver;
  tEBUSdriver feEBUSdriver;

`include "kl-backplane.svh"

  bit [3:0] top_clkPh = 4'b0001;
  bit ph1, ph2, ph3, ph4;

  assign ph1 = top_clkPh[0];
  assign ph2 = top_clkPh[1];
  assign ph3 = top_clkPh[2];
  assign ph4 = top_clkPh[3];

  // First two phases of our four phase clock are the master clock 1,
  // last two are 0.
  assign clk_master = |top_clkPh[3:2];

  // Maintain our four clock phases, rotating phases left each time.
  always_ff @(posedge top_clk) top_clkPh = {top_clkPh[2:0], top_clkPh[3]};

  // On a real KL10 this is a wire that traverses the width of the
  // backplane to provide delay equivalent to that experienced by the
  // worst case backplane slot. On this implementation, we can just
  // delay it one half cycle.
//  always_comb clk1_clk_h = !clk1_clk_out_h;
  always_comb clk1_clk_h = clk1_clk_out_h;

  iEBUS ebus();
  fe_sim feSim (.EBUSdriver(feEBUSdriver), .clk(!clk_10_11_clk_h), .*);

  iMBUS mbus();
  mb20 #(.MEMSIZE(512*1024)) memory0(.mbus(mbus.memory), .*);

  // Driving signals from KL10 MBOX to memory.
  always_comb begin
    mbus.mbox.startA = crobar_e_h ? 0 : mem_start_a_h;
    mbus.mbox.startB = crobar_e_h ? 0 : mem_start_b_h;
    mbus.mbox.memReset = crobar_e_h | diag_mem_reset_h;

    mbus.mbox.clk = clk_sbus_clk_h;
    mbus.mbox.rdRq = mem_rd_rq_h;
    mbus.mbox.wrRq = mem_wr_rq_h;
    mbus.mbox.rq = {mem_rq_0_h, mem_rq_1_h, mem_rq_2_h, mem_rq_3_h};
    mbus.mbox.adr = {pma_14_h, pma_15_h, pma_16_h, pma_17_h, pma_18_h,
		     pma_19_h, pma_20_h, pma_21_h, pma_22_h, pma_23_h,
		     pma_24_h, pma_25_h, pma_26_h, pma_27_h, pma_28_h,
		     pma_29_h, pma_30_h, pma_31_h, pma_32_h, pma_33_h,
		     pma_34_h, pma_35_h};
    mbus.mbox.adrPar = mem_adr_par_h;
    mbus.mbox.diag = !mem_diag_l;
    mbus.mbox.dOut = {mb_00_h, mb_01_h, mb_02_h, mb_03_h, mb_04_h, mb_05_h,
		      mb_06_h, mb_07_h, mb_08_h, mb_09_h, mb_10_h, mb_11_h,
		      mb_12_h, mb_13_h, mb_14_h, mb_15_h, mb_16_h, mb_17_h,
		      mb_18_h, mb_19_h, mb_20_h, mb_21_h, mb_22_h, mb_23_h,
		      mb_24_h, mb_25_h, mb_26_h, mb_27_h, mb_28_h, mb_29_h,
		      mb_30_h, mb_31_h, mb_32_h, mb_33_h, mb_34_h, mb_35_h};
    mbus.mbox.parOut = mb_par_h;
    mbus.mbox.adrHold = sbus_adr_hold_h;
    mbus.mbox.validOutA = data_valid_a_out_h;
    mbus.mbox.validOutB = data_valid_b_out_h;
  end

  // Receiving signals from memory to KL10 MBOX.
  always_comb begin
    {mem_data_in_00_h, mem_data_in_01_h, mem_data_in_02_h, mem_data_in_03_h,
     mem_data_in_04_h, mem_data_in_05_h, mem_data_in_06_h, mem_data_in_07_h,
     mem_data_in_08_h, mem_data_in_09_h, mem_data_in_10_h, mem_data_in_11_h,
     mem_data_in_12_h, mem_data_in_13_h, mem_data_in_14_h, mem_data_in_15_h,
     mem_data_in_16_h, mem_data_in_17_h, mem_data_in_18_h, mem_data_in_19_h,
     mem_data_in_20_h, mem_data_in_21_h, mem_data_in_22_h, mem_data_in_23_h,
     mem_data_in_24_h, mem_data_in_25_h, mem_data_in_26_h, mem_data_in_27_h,
     mem_data_in_28_h, mem_data_in_29_h, mem_data_in_30_h, mem_data_in_31_h,
     mem_data_in_32_h, mem_data_in_33_h, mem_data_in_34_h, mem_data_in_35_h} = mbus.mbox.dIn;
    mem_par_in_h = mbus.mbox.parIn;
    mem_ackn_a_h = mbus.mbox.acknA;
    mem_ackn_b_h = mbus.mbox.acknB;
    mem_data_valid_a_l = !mbus.mbox.validInA;
    mem_data_valid_b_l = !mbus.mbox.validInB;
    mem_error_h = 0;
    mem_adr_par_err_h = 0;
  end

  apr34 apr_34(.EBUSdriver(aprEBUSdriver), .*);
  ccl11 ccl_11(.EBUSdriver(cclEBUSdriver), .*);
  ccw12 ccw_12(.EBUSdriver(ccwEBUSdriver), .*);

`ifdef CACHELESS
  ch017 ch0_17(.*);
  ch019 ch0_19(.*);
  ch024 ch0_24(.*);
  ch025 ch0_25(.*);
  c0a27 c0a_27(.*);
  c0x28 c0x_28(.*);
`else
  cac17 cac_17(.*);
  cac19 cac_19(.*);
  cac24 cac_24(.*);
  cac25 cac_25(.*);
  cha27 cha_27(.*);
  chx28 chx_28(.EBUSdriver(chxEBUSdriver), .*);
`endif

  chc09 chc_09(.EBUSdriver(chcEBUSdriver), .*);
  clk32 clk_32(.EBUSdriver(clkEBUSdriver), .*);
  con35 con_35(.EBUSdriver(conEBUSdriver), .*);
  cra45 cra_45(.EBUSdriver(craEBUSdriver), .*);
  crc10 crc_10(.EBUSdriver(crcEBUSdriver), .*);
  crm40 crm_40(.EBUSdriver(crm40EBUSdriver), .*);
  crm42 crm_42(.EBUSdriver(crm42EBUSdriver), .*);
  crm44 crm_44(.EBUSdriver(crm44EBUSdriver), .*);
  crm50 crm_50(.EBUSdriver(crm50EBUSdriver), .*);
  crm52 crm_52(.EBUSdriver(crm52EBUSdriver), .*);
  csh23 csh_23(.EBUSdriver(cshEBUSdriver), .*);
  ctl36 ctl_36(.EBUSdriver(ctlEBUSdriver), .*);
  edp39 edp_39(.EBUSdriver(edp39EBUSdriver), .*);
  edp41 edp_41(.EBUSdriver(edp41EBUSdriver), .*);
  edp43 edp_43(.EBUSdriver(edp43EBUSdriver), .*);
  edp49 edp_49(.EBUSdriver(edp49EBUSdriver), .*);
  edp51 edp_51(.EBUSdriver(edp51EBUSdriver), .*);
  edp53 edp_53(.EBUSdriver(edp53EBUSdriver), .*);
  ird48 ird_48(.EBUSdriver(irdEBUSdriver), .*);
  mb014 mb0_14(.*);
  mb015 mb0_15(.*);
  mb016 mb0_16(.*);
  mbc22 mbc_22(.EBUSdriver(mbcEBUSdriver), .*);
  mbx21 mbx_21(.EBUSdriver(mbxEBUSdriver), .*);
  mbz20 mbz_20(.EBUSdriver(mbzEBUSdriver), .*);
  mcl47 mcl_47(.EBUSdriver(mclEBUSdriver), .*);
  mtr33 mtr_33(.EBUSdriver(mtrEBUSdriver), .*);
  pag30 pag_30(.*);
  pic31 pic_31(.EBUSdriver(picEBUSdriver), .*);
  pma29 pma_29(.*);
  scd54 scd_54(.EBUSdriver(scdEBUSdriver), .*);
  shm46 shm_46(.*);
  vma38 vma_38(.EBUSdriver(vmaEBUSdriver), .*);

  // Zero out our unused EBUS interface signals
  always_comb begin
    ebus.cs = 0;
    ebus.pi = 0;
    ebus.xfer = 0;
  end

  // Pass output of our EBUS driving mux back into the KL10 symbol
  // naming system for modules to read the EBUS data.
  always_comb begin

    {ebus_d00_e_h, ebus_d01_e_h, ebus_d02_e_h, ebus_d03_e_h, ebus_d04_e_h, ebus_d05_e_h,
     ebus_d06_e_h, ebus_d07_e_h, ebus_d08_e_h, ebus_d09_e_h, ebus_d10_e_h, ebus_d11_e_h,
     ebus_d12_e_h, ebus_d13_e_h, ebus_d14_e_h, ebus_d15_e_h, ebus_d16_e_h, ebus_d17_e_h,
     ebus_d18_e_h, ebus_d19_e_h, ebus_d20_e_h, ebus_d21_e_h, ebus_d22_e_h, ebus_d23_e_h,
     ebus_d24_e_h, ebus_d25_e_h, ebus_d26_e_h, ebus_d27_e_h, ebus_d28_e_h, ebus_d29_e_h,
     ebus_d30_e_h, ebus_d31_e_h, ebus_d32_e_h, ebus_d33_e_h, ebus_d34_e_h, ebus_d35_e_h} = ebus.data;

    ebus_ds_strobe_e_h = ebus.diagStrobe;
    ebus.demand = ebus_demand_e_h;
    ebus_xfer_e_h = ebus.xfer;

    ebus_ds00_e_h = ebus.ds[0];
    ebus_ds01_e_h = ebus.ds[1];
    ebus_ds02_e_h = ebus.ds[2];
    ebus_ds03_e_h = ebus.ds[3];
    ebus_ds04_e_h = ebus.ds[4];
    ebus_ds05_e_h = ebus.ds[5];
    ebus_ds06_e_h = ebus.ds[6];

    ebus.cs = {ebus_cs00_e_h, ebus_cs01_e_h, ebus_cs02_e_h, ebus_cs03_e_h,
	       ebus_cs04_e_h, ebus_cs05_e_h, ebus_cs06_e_h};

    ebus_pi00_e_h = ebus.pi[0];
    ebus_pi01_e_h = ebus.pi[1];
    ebus_pi02_e_h = ebus.pi[2];
    ebus_pi03_e_h = ebus.pi[3];
    ebus_pi04_e_h = ebus.pi[4];
    ebus_pi05_e_h = ebus.pi[5];
    ebus_pi06_e_h = ebus.pi[6];
    ebus_pi07_e_h = ebus.pi[7];

    ebus_parity_active_e_h = 0;
    ebus_parity_e_h = 0;
  end

  // "Mux" for EBUS data lines
  always_comb begin
    if (feEBUSdriver.driving) ebus.data = feEBUSdriver.data;
    else if (aprEBUSdriver.driving) ebus.data = aprEBUSdriver.data;
    else if (cclEBUSdriver.driving) ebus.data = cclEBUSdriver.data;
    else if (ccwEBUSdriver.driving) ebus.data = ccwEBUSdriver.data;
    else if (chcEBUSdriver.driving) ebus.data = chcEBUSdriver.data;
    else if (chxEBUSdriver.driving) ebus.data = chxEBUSdriver.data;
    else if (clkEBUSdriver.driving) ebus.data = clkEBUSdriver.data;
    else if (conEBUSdriver.driving) ebus.data = conEBUSdriver.data;

    else if (crm40EBUSdriver.driving | crm42EBUSdriver.driving |
	     crm44EBUSdriver.driving | crm50EBUSdriver.driving |
	     crm52EBUSdriver.driving)
    begin
      ebus.data[30:35] = crm40EBUSdriver.data[30:35];
      ebus.data[24:29] = crm42EBUSdriver.data[24:29];
      ebus.data[18:23] = crm44EBUSdriver.data[18:23];
      ebus.data[12:17] = crm50EBUSdriver.data[12:17];
      ebus.data[06:11] = crm52EBUSdriver.data[06:11];
      ebus.data[0:5] = craEBUSdriver.data[0:5];
    end
    else if (cshEBUSdriver.driving) ebus.data = cshEBUSdriver.data;
    else if (ctlEBUSdriver.driving) ebus.data = ctlEBUSdriver.data;

    else if (edp39EBUSdriver.driving | edp41EBUSdriver.driving |
	     edp43EBUSdriver.driving | edp49EBUSdriver.driving |
	     edp51EBUSdriver.driving | edp53EBUSdriver.driving)
    begin
      ebus.data[30:35] = edp39EBUSdriver.data[30:35];
      ebus.data[24:29] = edp41EBUSdriver.data[24:29];
      ebus.data[18:23] = edp43EBUSdriver.data[18:23];
      ebus.data[12:17] = edp49EBUSdriver.data[12:17];
      ebus.data[06:11] = edp51EBUSdriver.data[06:11];
      ebus.data[00:05] = edp53EBUSdriver.data[00:05];
    end else if (irdEBUSdriver.driving) ebus.data = irdEBUSdriver.data;
    else if (mbcEBUSdriver.driving) ebus.data = mbcEBUSdriver.data;
    else if (mbxEBUSdriver.driving) ebus.data = mbxEBUSdriver.data;
    else if (mbzEBUSdriver.driving) ebus.data = mbzEBUSdriver.data;
    else if (mclEBUSdriver.driving) ebus.data = mclEBUSdriver.data;
    else if (mtrEBUSdriver.driving) ebus.data = mtrEBUSdriver.data;
    else if (picEBUSdriver.driving) ebus.data = picEBUSdriver.data;
    else if (scdEBUSdriver.driving) ebus.data = scdEBUSdriver.data;
    else if (vmaEBUSdriver.driving) ebus.data = vmaEBUSdriver.data;
    else ebus.data = '0;
  end // always_comb
  

  // Assign '0' to all undriven nets we KNOW are meant to be undriven
  // so they stop causing warnings.
  always_comb begin
    apr3_spare_l = 0;
    apr_apr_par_chk_en_l = 0;	// XXX This is never assigned anywhere (used in CLK4)
    cra2_spare_h = 0;
    clk_resp_sim_h = 0;
    external_clk_h = 0;
    deskew_clk_h = 0;
    ctl3_diag_spare_l = 0;
    synchronize_clk_h = 0;
    probe_h = 0;

    // This comes from a selector that I think is correct
    mbz2_not_connected_h = 0;

    ccw_fast_mode_tp_h = 0;	// This is some sort of option?
    ccw_mem_store_tp_h = 0;	// This is only wireOR to assert CCW2 MEM STORE IN H?

    // For now
    pwr_warn_e_h = 0;

    // This is not defined anywhere, but making it constantly asserted seems good?
    ccl_ch_buf_en_l = 0;

    // These are not defined anywhere but are readable through DISP/EA MOD I think.
    ea_type_07_h = 0;
    ea_type_08_h = 0;
    ea_type_09_h = 0;
    ea_type_10_h = 0;

    // Field service signals.
    clk3_fs_en_a_h = 0;
    clk3_fs_en_b_h = 0;
    clk3_fs_en_c_h = 0;
    clk3_fs_en_d_h = 0;
    // Should these active-low pins be driven high by default? It
    // doesn't look like there is provision to do so in the design.
    clk3_fs_en_e_l = 0;
    clk3_fs_en_f_l = 0;
    clk3_fs_en_g_l = 0;

    // It looks like KL10 model B has a feature where you can
    // disconnect the metering carry bit for the counters. I'll just
    // connect them all, which I presume is the default backplane
    // wiring.
    mtr1_cache_cry_10_in_l = mtr1_cache_cry_10_l;
    mtr1_ebox_cry_10_in_l = mtr1_ebox_cry_10_l;
    mtr1_interval_cry_14_in_l = mtr1_interval_cry_14_l;
    mtr1_perf_cry_10_in_l = mtr1_perf_cry_10_l;
    mtr1_time_cry_10_in_l = mtr1_time_cry_10_l;

    // CRAM # is only nine bits, but EDP implements it in each EDP slot.
    cram_NR_09_h = 0;
    cram_NR_10_h = 0;
    cram_NR_11_h = 0;
    cram_NR_12_h = 0;
    cram_NR_13_h = 0;
    cram_NR_14_h = 0;
    cram_NR_15_h = 0;
    cram_NR_16_h = 0;
    cram_NR_17_h = 0;
    cram_NR_18_h = 0;
    cram_NR_19_h = 0;
    cram_NR_20_h = 0;
    cram_NR_21_h = 0;
    cram_NR_22_h = 0;
    cram_NR_23_h = 0;
    cram_NR_24_h = 0;
    cram_NR_25_h = 0;
    cram_NR_26_h = 0;
    cram_NR_27_h = 0;
    cram_NR_28_h = 0;
    cram_NR_29_h = 0;
    cram_NR_30_h = 0;
    cram_NR_31_h = 0;
    cram_NR_32_h = 0;
    cram_NR_33_h = 0;
    cram_NR_34_h = 0;
    cram_NR_35_h = 0;

    // ARMM is only nine bits, but EDP implements it in each EDP slot.
    armm_09_h = 0;
    armm_10_h = 0;
    armm_11_h = 0;
    armm_12_h = 0;

    // Backplane wiring implied in VMA4 PDF357.
    armm_13_h = vma4_vma_13_in_h; 
    armm_14_h = vma4_vma_14_in_h;
    armm_15_h = vma4_vma_15_in_h;
    armm_16_h = vma4_vma_16_in_h;
    armm_17_h = vma4_vma_17_in_h;

    armm_18_h = 0;
    armm_19_h = 0;
    armm_20_h = 0;
    armm_21_h = 0;
    armm_22_h = 0;
    armm_23_h = 0;
    armm_24_h = 0;
    armm_25_h = 0;
    armm_26_h = 0;
    armm_27_h = 0;
    armm_28_h = 0;
    armm_29_h = 0;
    armm_30_h = 0;
    armm_31_h = 0;
    armm_32_h = 0;
    armm_33_h = 0;
    armm_34_h = 0;
    armm_35_h = 0;

    arx_36_h = 0;
    arx_37_h = 0;

    bp_only_er2_h = 0;
    bp_only_es2_h = 0;

    brx_36_h = 0;

    // For now CBUS is not connected.
    cbus_ctom_e_h = 0;
    cbus_d00_re_h = 0;
    cbus_d01_re_h = 0;
    cbus_d02_re_h = 0;
    cbus_d03_re_h = 0;
    cbus_d04_re_h = 0;
    cbus_d05_re_h = 0;
    cbus_d06_re_h = 0;
    cbus_d07_re_h = 0;
    cbus_d08_re_h = 0;
    cbus_d09_re_h = 0;
    cbus_d10_re_h = 0;
    cbus_d11_re_h = 0;
    cbus_d12_re_h = 0;
    cbus_d13_re_h = 0;
    cbus_d14_re_h = 0;
    cbus_d15_re_h = 0;
    cbus_d16_re_h = 0;
    cbus_d17_re_h = 0;
    cbus_d18_re_h = 0;
    cbus_d19_re_h = 0;
    cbus_d20_re_h = 0;
    cbus_d21_re_h = 0;
    cbus_d22_re_h = 0;
    cbus_d23_re_h = 0;
    cbus_d24_re_h = 0;
    cbus_d25_re_h = 0;
    cbus_d26_re_h = 0;
    cbus_d27_re_h = 0;
    cbus_d28_re_h = 0;
    cbus_d29_re_h = 0;
    cbus_d30_re_h = 0;
    cbus_d31_re_h = 0;
    cbus_d32_re_h = 0;
    cbus_d33_re_h = 0;
    cbus_d34_re_h = 0;
    cbus_d35_re_h = 0;
    cbus_done_e_h = 0;
    cbus_par_left_re_h = 0;
    cbus_par_right_re_h = 0;
    cbus_request_e_h = 0;
    cbus_reset_e_h = 0;
    cbus_start_e_h = 0;
    cbus_store_e_h = 0;
 end

`ifdef CACHELESS
  // These are all of the signals that have no driver when we build a
  // cacheless KL10.
  always_comb begin
    chxEBUSdriver.driving = 0;
    chxEBUSdriver.data = 0;
  end
`endif

endmodule // kl10pv
