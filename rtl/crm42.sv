module crm42(
  /* <cr2> */ input  clk_crm_12_h,
  /* <af2> */ output cr02_dia_func_050_12_l,
  /* <ae2> */ output cr02_dia_func_051_12_l,
  /* <ae1> */ output cr02_dia_func_052_12_l,
  /* <ad2> */ output cr02_dia_func_053_12_l,
  /* <fj2> */ input  cra1_adr_00_d_h,
  /* <cs2> */ input  cra1_adr_01_d_h,
  /* <cm2> */ input  cra1_adr_02_d_h,
  /* <cp2> */ input  cra1_adr_03_d_h,
  /* <cu2> */ input  cra1_adr_04_d_h,
  /* <de2> */ input  cra1_adr_05_d_h,
  /* <df2> */ input  cra1_adr_06_d_h,
  /* <dj2> */ input  cra2_adr_07_d_h,
  /* <cv2> */ input  cra2_adr_08_d_h,
  /* <dd2> */ input  cra2_adr_09_d_h,
  /* <dk2> */ input  cra2_adr_10_d_h,
  /* <bv2> */ input  cra3_disp_parity_h,
  /* <cd2> */ output cram_par_12_h,
  /* <de1> */ output crm_hi_12_h,
  /* <ad1> */ input  diag_04_b_l,
  /* <dm2> */ input  diag_05_a_l,
  /* <af1> */ input  diag_05_b_l,
  /* <ds2> */ input  diag_06_a_l,
  /* <aj2> */ input  diag_06_b_l,
  /* <aj1> */ input  diag_load_func_05x_l,
  /* <ce2> */ input  diag_read_func_14x_l,
  /* <dt2> */ output ebus_d26_e_h,
  /* <dp1> */ output ebus_d27_e_h,
  /* <dp2> */ output ebus_d28_e_h,
  /* <du2> */ output ebus_d29_e_h,
  /* <al2> */ input  mr_reset_01_h
);

`include "crm42nets.svh"

endmodule	// crm42
