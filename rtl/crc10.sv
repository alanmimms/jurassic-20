module crc10(
      input  ccl_act_flag_req_l                /* <dh2> */,
      input  ccl_ccwf_clr_h                    /* <cj1> */,
      input  ccl_error_h                       /* <bp2> */,
      input  ccl_last_xfer_err_in_h            /* <ef2> */,
      input  ccl_load_ac_h                     /* <br2> */,
      input  ccl_load_ac_l                     /* <bm2> */,
      input  ccl_mb_cyc_t2_l                   /* <ae2> */,
      input  ccl_mb_req_t2_l                   /* <dj2> */,
      input  ccl_mem_store_req_l               /* <dd2> */,
      input  ccl_op_load_h                     /* <ej2> */,
      input  ccl_op_load_l                     /* <ef1> */,
      input  ccl_ram_req_l                     /* <at2> */,
      input  ccl_req_ctr_en_l                  /* <ad2> */,
      input  ccl_wcEq0_in_h                    /* <ct2> */,
      input  ccl_wcEq0_in_l                    /* <df2> */,
      input  ccw_act_ctr_0_en_l                /* <bl2> */,
      input  ccw_act_ctr_1_en_l                /* <be2> */,
      input  ccw_act_ctr_2_en_l                /* <bf2> */,
      input  ccw_buf_00_in_l                   /* <ep2> */,
      input  ccw_buf_01_in_l                   /* <en1> */,
      input  ccw_buf_02_in_l                   /* <eh2> */,
      input  ccw_ccwf_waiting_h                /* <ch2> */,
      input  ch_cbus_req_h                     /* <av2> */,
      input  ch_cbus_req_l                     /* <ds2> */,
      input  ch_contr_req_h                    /* <au2> */,
      input  ch_contr_req_l                    /* <cf2> */,
      input  ch_done_intr_l                    /* <ep1> */,
      input  ch_mr_reset_b_h                   /* <bt2> */,
      input  ch_req_d_l                        /* <ff2> */,
      input  ch_reset_intr_h                   /* <cv2> */,
      input  ch_reset_intr_l                   /* <el1> */,
      input  ch_start_intr_h                   /* <cu2> */,
      input  ch_start_intr_l                   /* <ck2> */,
      input  ch_start_l                        /* <cl2> */,
      input  ch_store_h                        /* <du2> */,
      input  clk_crc_h                         /* <cr2> */,
      output crc_act_ctr_0_h                   /* <bh2> */,
      output crc_act_ctr_1_h                   /* <bj2> */,
      output crc_act_ctr_2_h                   /* <bd2> */,
      output crc_act_ctr_2r_l                  /* <bk2> */,
      output crc_act_flag_ena_l                /* <de2> */,
      output crc_cbus_contr_cyc_l              /* <fr1> */,
      output crc_cbus_out_hold_h               /* <ee1> */,
      output crc_ccwf_en_l                     /* <cj2> */,
      output crc_err_in_h                      /* <ev2> */,
      output crc_last_word_in_h                /* <ed2> */,
      output crc_long_wc_err_h                 /* <em2> */,
      output crc_mb_cyc_h                      /* <ek1> */,
      output crc_mb_cyc_l                      /* <fn1> */,
      output crc_mem_store_ena_l               /* <ed1> */,
      output crc_ovn_err_in_h                  /* <el2> */,
      input  crc_ram_adr_1r_h                  /* <as2> */,
      input  crc_ram_adr_2r_h                  /* <ar2> */,
      input  crc_ram_adr_4r_h                  /* <am2> */,
      output crc_ram_cyc_l                     /* <cs2> */,
      output crc_ready_in_h                    /* <dr1> */,
      output crc_req_d_h                       /* <dt2> */,
      output crc_req_e_l                       /* <fv2> */,
      output crc_reset_l                       /* <ek2> */,
      output crc_reverse_in_h                  /* <em1> */,
      output crc_rh20_err_in_h                 /* <dr2> */,
      output crc_short_wc_err_h                /* <eu2> */,
      input  crc_wr_ram_l                      /* <ap2> */
);

`include "crc10nets.svh"

endmodule	// crc10
