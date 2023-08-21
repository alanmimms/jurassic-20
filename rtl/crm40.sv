module crm40(
  /* <cr2> */ input  clk_crm_16_h,
  /* <af2> */ output cr02_dia_func_050_16_l,
  /* <ae2> */ output cr02_dia_func_051_16_l,
  /* <ae1> */ output cr02_dia_func_052_16_l,
  /* <ad2> */ output cr02_dia_func_053_16_l,
  /* <fj2> */ input  cra1_adr_00_e_h,
  /* <cs2> */ input  cra1_adr_01_e_l,
  /* <cm2> */ input  cra1_adr_02_e_l,
  /* <cp2> */ input  cra1_adr_03_e_l,
  /* <cu2> */ input  cra1_adr_04_e_l,
  /* <de2> */ input  cra1_adr_05_e_l,
  /* <df2> */ input  cra1_adr_06_e_l,
  /* <dj2> */ input  cra2_adr_07_e_h,
  /* <cv2> */ input  cra2_adr_08_e_h,
  /* <dd2> */ input  cra2_adr_09_e_h,
  /* <dk2> */ input  cra2_adr_10_e_h,
  /* <bv2> */ input  cram_par_00_h,
  /* <bu2> */ input  cram_par_04_h,
  /* <br2> */ input  cram_par_08_h,
  /* <bs2> */ input  cram_par_12_h,
  /* <cd2> */ output cram_par_16_h,
  /* <de1> */ output crm_hi_16_h,
  /* <ad1> */ input  diag_04_b_l,
  /* <dm2> */ input  diag_05_a_l,
  /* <af1> */ input  diag_05_b_l,
  /* <ds2> */ input  diag_06_a_l,
  /* <aj2> */ input  diag_06_b_l,
  /* <aj1> */ input  diag_load_func_05x_l,
  /* <ce2> */ input  diag_read_func_14x_l,
  /* <dt2> */ output ebus_d32_e_h,
  /* <dp1> */ output ebus_d33_e_h,
  /* <dp2> */ output ebus_d34_e_h,
  /* <du2> */ output ebus_d35_e_h,
  /* <al2> */ input  mr_reset_01_h
);

`include "crm40nets.svh"

endmodule	// crm40