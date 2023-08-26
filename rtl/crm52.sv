module crm52(
      input  clk_crm_00_h                      /* <cr2> */,
      output cr02_dia_func_050_00_l            /* <af2> */,
      output cr02_dia_func_051_00_l            /* <ae2> */,
      output cr02_dia_func_052_00_l            /* <ae1> */,
      output cr02_dia_func_053_00_l            /* <ad2> */,
      input  cra1_adr_00_a_h                   /* <fj2> */,
      input  cra1_adr_01_a_l                   /* <cs2> */,
      input  cra1_adr_02_a_l                   /* <cm2> */,
      input  cra1_adr_03_a_l                   /* <cp2> */,
      input  cra1_adr_04_a_l                   /* <cu2> */,
      input  cra1_adr_05_a_l                   /* <de2> */,
      input  cra1_adr_06_a_l                   /* <df2> */,
      input  cra2_adr_07_a_h                   /* <dj2> */,
      input  cra2_adr_08_a_h                   /* <cv2> */,
      input  cra2_adr_09_a_h                   /* <dd2> */,
      input  cra2_adr_10_a_h                   /* <dk2> */,
      output cram_par_00_h                     /* <cd2> */,
      output crm_hi_00_h                       /* <de1> */,
      input  diag_04_b_l                       /* <ad1> */,
      input  diag_05_a_l                       /* <dm2> */,
      input  diag_05_b_l                       /* <af1> */,
      input  diag_06_a_l                       /* <ds2> */,
      input  diag_06_b_l                       /* <aj2> */,
      input  diag_load_func_05x_l              /* <aj1> */,
      input  diag_read_func_14x_l              /* <ce2> */,
      output ebus_d08_e_h                      /* <dt2> */,
      output ebus_d09_e_h                      /* <dp1> */,
      output ebus_d10_e_h                      /* <dp2> */,
      output ebus_d11_e_h                      /* <du2> */,
      input  mr_reset_01_h                     /* <al2> */
);

`include "crm52nets.svh"

endmodule	// crm52
