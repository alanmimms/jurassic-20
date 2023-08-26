module crm50(
      input  clk_crm_04_h                      /* <cr2> */,
      output cr02_dia_func_050_04_l            /* <af2> */,
      output cr02_dia_func_051_04_l            /* <ae2> */,
      output cr02_dia_func_052_04_l            /* <ae1> */,
      output cr02_dia_func_053_04_l            /* <ad2> */,
      input  cra1_adr_00_b_h                   /* <fj2> */,
      input  cra1_adr_01_b_h                   /* <cs2> */,
      input  cra1_adr_02_b_h                   /* <cm2> */,
      input  cra1_adr_03_b_h                   /* <cp2> */,
      input  cra1_adr_04_b_h                   /* <cu2> */,
      input  cra1_adr_05_b_h                   /* <de2> */,
      input  cra1_adr_06_b_h                   /* <df2> */,
      input  cra2_adr_07_b_h                   /* <dj2> */,
      input  cra2_adr_08_b_h                   /* <cv2> */,
      input  cra2_adr_09_b_h                   /* <dd2> */,
      input  cra2_adr_10_b_h                   /* <dk2> */,
      output cram_par_04_h                     /* <cd2> */,
      output crm_hi_04_h                       /* <de1> */,
      input  diag_04_b_l                       /* <ad1> */,
      input  diag_05_a_l                       /* <dm2> */,
      input  diag_05_b_l                       /* <af1> */,
      input  diag_06_a_l                       /* <ds2> */,
      input  diag_06_b_l                       /* <aj2> */,
      input  diag_load_func_05x_l              /* <aj1> */,
      input  diag_read_func_14x_l              /* <ce2> */,
      output ebus_d14_e_h                      /* <dt2> */,
      output ebus_d15_e_h                      /* <dp1> */,
      output ebus_d16_e_h                      /* <dp2> */,
      output ebus_d17_e_h                      /* <du2> */,
      input  mr_reset_01_h                     /* <al2> */
);

`include "crm50nets.svh"

endmodule	// crm50
