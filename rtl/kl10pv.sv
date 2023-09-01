// The top of the hierarchy for KL10PV CPU and its front end, memory,
// peripherals, and power system.
module kl10pv(input clk60, crobar);

`include "kl-backplane.svh"

  bit aprEBUSdrive, cclEBUSdrive, ccwEBUSdrive, chcEBUSdrive, chxEBUSdrive;
  bit clkEBUSdrive, conEBUSdrive, craEBUSdrive;
  bit crm40EBUSdrive, crm42EBUSdrive, crm44EBUSdrive, crm50EBUSdrive, crm52EBUSdrive;
  bit cshEBUSdrive, ctlEBUSdrive;
  bit edp39EBUSdrive, edp41EBUSdrive, edp43EBUSdrive, edp49EBUSdrive, edp51EBUSdrive, edp53EBUSdrive;
  bit irdEBUSdrive, mbcEBUSdrive, mbxEBUSdrive;
  bit mbzEBUSdrive, mclEBUSdrive, mtrEBUSdrive, picEBUSdrive, scdEBUSdrive;
  bit vmaEBUSdrive;

  assign clk = clk60;
  assign crobar_e_h = crobar;

  apr34 apr_34(.EBUSdrive(aprEBUSdrive), .*);
  cac17 cac_17(.*);
  cac19 cac_19(.*);
  cac24 cac_24(.*);
  cac25 cac_25(.*);
  ccl11 ccl_11(.EBUSdrive(cclEBUSdrive), .*);
  ccw12 ccw_12(.EBUSdrive(ccwEBUSdrive), .*);
  cha27 cha_27(.*);
  chc09 chc_09(.EBUSdrive(chcEBUSdrive), .*);
  chx28 chx_28(.EBUSdrive(chxEBUSdrive), .*);
  clk32 clk_32(.EBUSdrive(clkEBUSdrive), .*);
  con35 con_35(.EBUSdrive(conEBUSdrive), .*);
  cra45 cra_45(.EBUSdrive(craEBUSdrive), .*);
  crc10 crc_10(.*);
  crm40 crm_40(.EBUSdrive(crm40EBUSdrive), .*);
  crm42 crm_42(.EBUSdrive(crm42EBUSdrive), .*);
  crm44 crm_44(.EBUSdrive(crm44EBUSdrive), .*);
  crm50 crm_50(.EBUSdrive(crm50EBUSdrive), .*);
  crm52 crm_52(.EBUSdrive(crm52EBUSdrive), .*);
  csh23 csh_23(.EBUSdrive(cshEBUSdrive), .*);
  ctl36 ctl_36(.EBUSdrive(ctlEBUSdrive), .*);
  edp39 edp_39(.EBUSdrive(edp39EBUSdrive), .*);
  edp41 edp_41(.EBUSdrive(edp41EBUSdrive), .*);
  edp43 edp_43(.EBUSdrive(edp43EBUSdrive), .*);
  edp49 edp_49(.EBUSdrive(edp49EBUSdrive), .*);
  edp51 edp_51(.EBUSdrive(edp51EBUSdrive), .*);
  edp53 edp_53(.EBUSdrive(edp53EBUSdrive), .*);
  ird48 ird_48(.EBUSdrive(irdEBUSdrive), .*);
  mb014 mb0_14(.*);
  mb015 mb0_15(.*);
  mb016 mb0_16(.*);
  mbc22 mbc_22(.EBUSdrive(mbcEBUSdrive), .*);
  mbx21 mbx_21(.EBUSdrive(mbxEBUSdrive), .*);
  mbz20 mbz_20(.EBUSdrive(mbzEBUSdrive), .*);
  mcl47 mcl_47(.EBUSdrive(mclEBUSdrive), .*);
  mtr33 mtr_33(.EBUSdrive(mtrEBUSdrive), .*);
  pag30 pag_30(.*);
  pic31 pic_31(.EBUSdrive(picEBUSdrive), .*);
  pma29 pma_29(.*);
  scd54 scd_54(.EBUSdrive(scdEBUSdrive), .*);
  shm46 shm_46(.*);
  vma38 vma_38(.EBUSdrive(vmaEBUSdrive), .*);


endmodule // kl10pv
