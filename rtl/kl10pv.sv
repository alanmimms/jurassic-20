// The top of the hierarchy for KL10PV CPU and its front end, memory,
// peripherals, and power system.
module kl10pv(input clk60);

`include "kl-backplane.svh"

  tEBUSdriver aprEBUSdriver, cclEBUSdriver, ccwEBUSdriver, chcEBUSdriver, chxEBUSdriver;
  tEBUSdriver clkEBUSdriver, conEBUSdriver, craEBUSdriver;
  tEBUSdriver crm40EBUSdriver, crm42EBUSdriver, crm44EBUSdriver, crm50EBUSdriver, crm52EBUSdriver;
  tEBUSdriver cshEBUSdriver, ctlEBUSdriver;
  tEBUSdriver edp39EBUSdriver, edp41EBUSdriver, edp43EBUSdriver, edp49EBUSdriver, edp51EBUSdriver, edp53EBUSdriver;
  tEBUSdriver irdEBUSdriver, mbcEBUSdriver, mbxEBUSdriver;
  tEBUSdriver mbzEBUSdriver, mclEBUSdriver, mtrEBUSdriver, picEBUSdriver, scdEBUSdriver;
  tEBUSdriver vmaEBUSdriver;
  tEBUSdriver feEBUSdriver;

  assign clk = clk60;

  iEBUS ebus();

  fe_sim feSim (.EBUSdriver(feEBUSdriver), .clk(clk_10_11_clk_h), .*);

  apr34 apr_34(.EBUSdriver(aprEBUSdriver), .*);
  cac17 cac_17(.*);
  cac19 cac_19(.*);
  cac24 cac_24(.*);
  cac25 cac_25(.*);
  ccl11 ccl_11(.EBUSdriver(cclEBUSdriver), .*);
  ccw12 ccw_12(.EBUSdriver(ccwEBUSdriver), .*);
  cha27 cha_27(.*);
  chc09 chc_09(.EBUSdriver(chcEBUSdriver), .*);
  chx28 chx_28(.EBUSdriver(chxEBUSdriver), .*);
  clk32 clk_32(.EBUSdriver(clkEBUSdriver), .*);
  con35 con_35(.EBUSdriver(conEBUSdriver), .*);
  cra45 cra_45(.EBUSdriver(craEBUSdriver), .*);
  crc10 crc_10(.*);
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

  // Pass output of our EBUS driving mux back into the KL10 symbol
  // naming system for modules to read the EBUS data.
  assign ebus_d00_e_h = ebus.data[00];
  assign ebus_d01_e_h = ebus.data[01];
  assign ebus_d02_e_h = ebus.data[02];
  assign ebus_d03_e_h = ebus.data[03];
  assign ebus_d04_e_h = ebus.data[04];
  assign ebus_d05_e_h = ebus.data[05];
  assign ebus_d06_e_h = ebus.data[06];
  assign ebus_d07_e_h = ebus.data[07];
  assign ebus_d08_e_h = ebus.data[08];
  assign ebus_d09_e_h = ebus.data[09];
  assign ebus_d10_e_h = ebus.data[10];
  assign ebus_d11_e_h = ebus.data[11];
  assign ebus_d12_e_h = ebus.data[12];
  assign ebus_d13_e_h = ebus.data[13];
  assign ebus_d14_e_h = ebus.data[14];
  assign ebus_d15_e_h = ebus.data[15];
  assign ebus_d16_e_h = ebus.data[16];
  assign ebus_d17_e_h = ebus.data[17];
  assign ebus_d18_e_h = ebus.data[18];
  assign ebus_d19_e_h = ebus.data[19];
  assign ebus_d20_e_h = ebus.data[20];
  assign ebus_d21_e_h = ebus.data[21];
  assign ebus_d22_e_h = ebus.data[22];
  assign ebus_d23_e_h = ebus.data[23];
  assign ebus_d24_e_h = ebus.data[24];
  assign ebus_d25_e_h = ebus.data[25];
  assign ebus_d26_e_h = ebus.data[26];
  assign ebus_d27_e_h = ebus.data[27];
  assign ebus_d28_e_h = ebus.data[28];
  assign ebus_d29_e_h = ebus.data[29];
  assign ebus_d30_e_h = ebus.data[30];
  assign ebus_d31_e_h = ebus.data[31];
  assign ebus_d32_e_h = ebus.data[32];
  assign ebus_d33_e_h = ebus.data[33];
  assign ebus_d34_e_h = ebus.data[34];
  assign ebus_d35_e_h = ebus.data[35];

  // Mux for EBUS data lines
  always_comb
    unique case (1)
      default: ebus.data = '0;
      feEBUSdriver.driving:	ebus.data = feEBUSdriver.data;
      aprEBUSdriver.driving:	ebus.data = aprEBUSdriver.data;
      cclEBUSdriver.driving:	ebus.data = cclEBUSdriver.data;
      ccwEBUSdriver.driving:	ebus.data = ccwEBUSdriver.data;
      chcEBUSdriver.driving:	ebus.data = chcEBUSdriver.data;
      chxEBUSdriver.driving:	ebus.data = chxEBUSdriver.data;
      clkEBUSdriver.driving:	ebus.data = clkEBUSdriver.data;
      conEBUSdriver.driving:	ebus.data = conEBUSdriver.data;
      craEBUSdriver.driving:	ebus.data = craEBUSdriver.data;
      crm40EBUSdriver.driving:	ebus.data = crm40EBUSdriver.data;
      crm42EBUSdriver.driving:	ebus.data = crm42EBUSdriver.data;
      crm44EBUSdriver.driving:	ebus.data = crm44EBUSdriver.data;
      crm50EBUSdriver.driving:	ebus.data = crm50EBUSdriver.data;
      crm52EBUSdriver.driving:	ebus.data = crm52EBUSdriver.data;
      cshEBUSdriver.driving:	ebus.data = cshEBUSdriver.data;
      ctlEBUSdriver.driving:	ebus.data = ctlEBUSdriver.data;
      edp39EBUSdriver.driving:	ebus.data = edp39EBUSdriver.data;
      edp41EBUSdriver.driving:	ebus.data = edp41EBUSdriver.data;
      edp43EBUSdriver.driving:	ebus.data = edp43EBUSdriver.data;
      edp49EBUSdriver.driving:	ebus.data = edp49EBUSdriver.data;
      edp51EBUSdriver.driving:	ebus.data = edp51EBUSdriver.data;
      edp53EBUSdriver.driving:	ebus.data = edp53EBUSdriver.data;
      irdEBUSdriver.driving:	ebus.data = irdEBUSdriver.data;
      mbcEBUSdriver.driving:	ebus.data = mbcEBUSdriver.data;
      mbxEBUSdriver.driving:	ebus.data = mbxEBUSdriver.data;
      mbzEBUSdriver.driving:	ebus.data = mbzEBUSdriver.data;
      mclEBUSdriver.driving:	ebus.data = mclEBUSdriver.data;
      mtrEBUSdriver.driving:	ebus.data = mtrEBUSdriver.data;
      picEBUSdriver.driving:	ebus.data = picEBUSdriver.data;
      scdEBUSdriver.driving:	ebus.data = scdEBUSdriver.data;
      vmaEBUSdriver.driving:	ebus.data = vmaEBUSdriver.data;
    endcase
  
endmodule // kl10pv
