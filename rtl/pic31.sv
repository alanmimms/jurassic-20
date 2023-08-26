module pic31(
      input  apr_apr_interrupt_l               /* <ds2> */,
      input  apr_ebox_disable_cs_h             /* <cs1> */,
      input  apr_ebox_send_f02_h               /* <dr2> */,
      input  apr_ebus_demand_h                 /* <am2> */,
      input  apr_ebus_req_l                    /* <bc1> */,
      input  apr_ebus_return_h                 /* <bd1> */,
      input  clk_pi_h                          /* <cr2> */,
      input  con_cono_apr_l                    /* <df1> */,
      input  con_cono_pi_l                     /* <fr2> */,
      input  con_ebus_rel_h                    /* <bd2> */,
      input  con_pi_cycle_b_l                  /* <at2> */,
      input  con_pi_disable_l                  /* <be1> */,
      input  con_pi_dismiss_l                  /* <fm2> */,
      input  con_set_pih_l                     /* <fu2> */,
      input  ctl_console_control_h             /* <be2> */,
      input  diag_04_b_h                       /* <dm2> */,
      input  diag_05_b_h                       /* <bk2> */,
      input  diag_06_b_h                       /* <bl1> */,
      input  diag_read_func_10x_l              /* <dm1> */,
      output ebus_cs00_e_h                     /* <ce1> */,
      output ebus_cs01_e_h                     /* <bs2> */,
      output ebus_cs02_e_h                     /* <bp2> */,
      output ebus_cs03_e_h                     /* <bl2> */,
      output ebus_cs04_e_h                     /* <ch2> */,
      output ebus_cs05_e_h                     /* <cc1> */,
      output ebus_cs06_e_h                     /* <br1> */,
      input  ebus_d00_e_h                      /* <cj1> */,
      input  ebus_d01_e_h                      /* <cf2> */,
      input  ebus_d02_e_h                      /* <cf1> */,
      output ebus_d03_e_h                      /* <ce2> */,
      output ebus_d04_e_h                      /* <cd2> */,
      output ebus_d05_e_h                      /* <cd1> */,
      output ebus_d06_e_h                      /* <cr1> */,
      output ebus_d07_e_h                      /* <df2> */,
      output ebus_d08_e_h                      /* <de2> */,
      output ebus_d09_e_h                      /* <da1> */,
      output ebus_d10_e_h                      /* <dd2> */,
      output ebus_d11_e_h                      /* <cp2> */,
      output ebus_d12_e_h                      /* <cl2> */,
      output ebus_d13_e_h                      /* <ck2> */,
      output ebus_d14_e_h                      /* <cj2> */,
      output ebus_d15_e_h                      /* <du2> */,
      output ebus_d16_e_h                      /* <dv2> */,
      output ebus_d17_e_h                      /* <dt2> */,
      output ebus_demand_e_h                   /* <bn1> */,
      output ebus_f00_e_h                      /* <ck1> */,
      output ebus_f02_e_h                      /* <fc1> */,
      input  ebus_pi00_e_h                     /* <fa1> */,
      input  ebus_pi01_e_h                     /* <aj1> */,
      input  ebus_pi02_e_h                     /* <ba1> */,
      input  ebus_pi03_e_h                     /* <dp2> */,
      input  ebus_pi04_e_h                     /* <dp1> */,
      input  ebus_pi05_e_h                     /* <dl1> */,
      input  ebus_pi06_e_h                     /* <dh2> */,
      input  ebus_pi07_e_h                     /* <cv2> */,
      input  ebus_xfer_e_h                     /* <ar1> */,
      input  ir_03_h                           /* <bk1> */,
      input  ir_04_h                           /* <bj2> */,
      input  ir_05_h                           /* <bf1> */,
      input  ir_06_h                           /* <bf2> */,
      input  ir_07_h                           /* <cm1> */,
      input  ir_08_h                           /* <cn1> */,
      input  ir_09_h                           /* <cl1> */,
      input  mr_reset_02_h                     /* <dl2> */,
      input  mtr_1_mhz_a_l                     /* <ac1> */,
      input  mtr_cono_mtrCm_l                  /* <dj2> */,
      input  mtr_vector_interrupt_l            /* <dn1> */,
      output pi2_ext_tran_rec_h                /* <aa1> */,
      output pi2_hold_1_h                      /* <fl2> */,
      output pi2_hold_2_h                      /* <fd2> */,
      output pi2_hold_4_h                      /* <fd1> */,
      output pi2_pi1_a_h                       /* <ff2> */,
      output pi2_pi1_a_l                       /* <fl1> */,
      output pi2_pi2_a_h                       /* <fh2> */,
      output pi2_pi2_a_l                       /* <fk2> */,
      input  pi2_pi4_a_h                       /* <fn1><fh1> */,
      output pi2_pi4_a_l                       /* <fe2> */,
      output pi2_ready_h                       /* <ca1> */,
      output pi3_apr_pia_01_h                  /* <dr1> */,
      output pi3_apr_pia_02_h                  /* <dk2> */,
      output pi3_apr_pia_04_h                  /* <dk1> */,
      output pi3_mtr_honor_h                   /* <de1> */,
      output pi3_mtr_pia_01_h                  /* <ct2> */,
      output pi3_mtr_pia_02_h                  /* <cu2> */,
      output pi3_mtr_pia_04_h                  /* <dj1> */,
      output pi4_send_2n_h                     /* <bm1> */,
      output pi5_ebus_cp_grant_h               /* <au2> */,
      output pi5_gate_ttl_to_ecl_l             /* <bh2> */,
      output pi_xor_on_bus_l                   /* <bj1> */
);

`include "pic31nets.svh"

endmodule	// pic31
