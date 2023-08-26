module crm44(
      input  clk_crm_08_h                      /* <cr2> */,
      output cr02_dia_func_050_08_l            /* <af2> */,
      output cr02_dia_func_051_08_l            /* <ae2> */,
      output cr02_dia_func_052_08_l            /* <ae1> */,
      output cr02_dia_func_053_08_l            /* <ad2> */,
      input  cra1_adr_00_c_h                   /* <fj2> */,
      input  cra1_adr_01_c_l                   /* <cs2> */,
      input  cra1_adr_02_c_l                   /* <cm2> */,
      input  cra1_adr_03_c_l                   /* <cp2> */,
      input  cra1_adr_04_c_l                   /* <cu2> */,
      input  cra1_adr_05_c_l                   /* <de2> */,
      input  cra1_adr_06_c_l                   /* <df2> */,
      input  cra2_adr_07_c_h                   /* <dj2> */,
      input  cra2_adr_08_c_h                   /* <cv2> */,
      input  cra2_adr_09_c_h                   /* <dd2> */,
      input  cra2_adr_10_c_h                   /* <dk2> */,
      input  cram_mark_h                       /* <bv2> */,
      output cram_par_08_h                     /* <cd2> */,
      output crm_hi_08_h                       /* <de1> */,
      input  diag_04_b_l                       /* <ad1> */,
      input  diag_05_a_l                       /* <dm2> */,
      input  diag_05_b_l                       /* <af1> */,
      input  diag_06_a_l                       /* <ds2> */,
      input  diag_06_b_l                       /* <aj2> */,
      input  diag_load_func_05x_l              /* <aj1> */,
      input  diag_read_func_14x_l              /* <ce2> */,
      output ebus_d20_e_h                      /* <dt2> */,
      output ebus_d21_e_h                      /* <dp1> */,
      output ebus_d22_e_h                      /* <dp2> */,
      output ebus_d23_e_h                      /* <du2> */,
      input  mr_reset_01_h                     /* <al2> */
);

`include "crm44nets.svh"

endmodule	// crm44
