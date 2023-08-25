// The top of the hierarchy for KL10PV CPU and its front end, memory,
// peripherals, and power system.
module kl10pv(input clk60, crobar);

`include "kl-backplane.svh"

  assign clk = clk60;
  assign crobar_e_h = crobar;

  apr34 apr_34(.*);
  cac17 cac_17(.*);
  cac19 cac_19(.*);
  cac24 cac_24(.*);
  cac25 cac_25(.*);
  ccl11 ccl_11(.*);
  ccw12 ccw_12(.*);
  cha27 cha_27(.*);
  chc09 chc_09(.*);
  chx28 chx_28(.*);
  clk32 clk_32(.*);
  con35 con_35(.*);
  cra45 cra_45(.*);
  crc10 crc_10(.*);
  crm40 crm_40(.*);
  crm42 crm_42(.*);
  crm44 crm_44(.*);
  crm50 crm_50(.*);
  crm52 crm_52(.*);
  csh23 csh_23(.*);
  ctl36 ctl_36(.*);
  edp39 edp_39(.*);
  edp41 edp_41(.*);
  edp43 edp_43(.*);
  edp49 edp_49(.*);
  edp51 edp_51(.*);
  edp53 edp_53(.*);
  ird48 ird_48(.*);
  mb014 mb0_14(.*);
  mb015 mb0_15(.*);
  mb016 mb0_16(.*);
  mbc22 mbc_22(.*);
  mbx21 mbx_21(.*);
  mbz20 mbz_20(.*);
  mcl47 mcl_47(.*);
  mtr33 mtr_33(.*);
  pag30 pag_30(.*);
  pic31 pic_31(.*);
  pma29 pma_29(.*);
  scd54 scd_54(.*);
  shm46 shm_46(.*);
  vma38 vma_38(.*);


endmodule // kl10pv
