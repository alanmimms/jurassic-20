module mb016(
      input  ar_00_a_h                         /* <fc1> */,
      input  ar_01_a_h                         /* <fd1> */,
      input  ar_02_a_h                         /* <eu2> */,
      input  ar_03_a_h                         /* <ev2> */,
      input  ar_04_a_h                         /* <cv2> */,
      input  ar_05_a_h                         /* <bu2> */,
      input  ar_18_a_h                         /* <dd2> */,
      input  ar_19_a_h                         /* <cs2> */,
      input  ar_20_a_h                         /* <bp1> */,
      input  ar_21_a_h                         /* <bj2> */,
      input  ar_22_a_h                         /* <bm2> */,
      input  ar_23_a_h                         /* <bf1> */,
      input  cache_data_00_a_h                 /* <er2> */,
      input  cache_data_01_a_h                 /* <ef1> */,
      input  cache_data_02_a_h                 /* <ff2> */,
      input  cache_data_03_a_h                 /* <er1> */,
      input  cache_data_04_a_h                 /* <cr1> */,
      input  cache_data_05_a_h                 /* <cm2> */,
      input  cache_data_18_a_h                 /* <dk2> */,
      input  cache_data_19_a_h                 /* <dk1> */,
      input  cache_data_20_a_h                 /* <am1> */,
      input  cache_data_21_a_h                 /* <ak1> */,
      input  cache_data_22_a_h                 /* <ar1> */,
      input  cache_data_23_a_h                 /* <ap1> */,
      input  cbus_d00_re_h                     /* <cj1> */,
      output cbus_d00_te_h                     /* <ee1> */,
      input  cbus_d01_re_h                     /* <cj2> */,
      output cbus_d01_te_h                     /* <ee2> */,
      input  cbus_d02_re_h                     /* <bs2> */,
      output cbus_d02_te_h                     /* <el2> */,
      input  cbus_d03_re_h                     /* <bc1> */,
      output cbus_d03_te_h                     /* <em1> */,
      input  cbus_d04_re_h                     /* <br1> */,
      output cbus_d04_te_h                     /* <df1> */,
      input  cbus_d05_re_h                     /* <bd2> */,
      output cbus_d05_te_h                     /* <dl2> */,
      input  cbus_d18_re_h                     /* <ch2> */,
      output cbus_d18_te_h                     /* <dn1> */,
      input  cbus_d19_re_h                     /* <cf1> */,
      output cbus_d19_te_h                     /* <dm2> */,
      input  cbus_d20_re_h                     /* <be2> */,
      output cbus_d20_te_h                     /* <ah2> */,
      input  cbus_d21_re_h                     /* <bj1> */,
      output cbus_d21_te_h                     /* <af2> */,
      input  cbus_d22_re_h                     /* <be1> */,
      output cbus_d22_te_h                     /* <aj2> */,
      input  cbus_d23_re_h                     /* <bl1> */,
      output cbus_d23_te_h                     /* <ak2> */,
      input  ccl_ccw_buf_wr_l                  /* <fk1> */,
      input  ccl_ch_buf_en_l                   /* <ae2> */,
      input  ccl_mix_mb_sel_h                  /* <es1> */,
      input  ccw_buf_00_in_h                   /* <fl1> */,
      input  ccw_buf_01_in_h                   /* <fm2> */,
      input  ccw_buf_02_in_h                   /* <fh2> */,
      input  ccw_buf_03_in_h                   /* <fj2> */,
      input  ccw_buf_04_in_h                   /* <cl2> */,
      input  ccw_buf_05_in_h                   /* <cl1> */,
      input  ccw_buf_18_in_h                   /* <ck2> */,
      input  ccw_buf_19_in_h                   /* <ck1> */,
      input  ccw_buf_20_in_h                   /* <at2> */,
      input  ccw_buf_21_in_h                   /* <as1> */,
      input  ccw_buf_22_in_h                   /* <ap2> */,
      input  ccw_buf_23_in_h                   /* <am2> */,
      input  ccw_buf_adr_0_h                   /* <fk2> */,
      input  ccw_buf_adr_1_h                   /* <fj1> */,
      input  ccw_buf_adr_2_h                   /* <fl2> */,
      input  ccw_buf_adr_3_h                   /* <fm1> */,
      output ccw_mix_00_h                      /* <ek2> */,
      output ccw_mix_01_h                      /* <eh2> */,
      output ccw_mix_02_h                      /* <ff1> */,
      output ccw_mix_03_h                      /* <es2> */,
      output ccw_mix_04_h                      /* <cp2> */,
      output ccw_mix_05_h                      /* <cn1> */,
      output ccw_mix_18_h                      /* <dl1> */,
      output ccw_mix_19_h                      /* <dh2> */,
      output ccw_mix_20_h                      /* <al2> */,
      output ccw_mix_21_h                      /* <al1> */,
      output ccw_mix_22_h                      /* <as2> */,
      output ccw_mix_23_h                      /* <ar2> */,
      input  ch_buf_wr_03_l                    /* <aj1> */,
      input  ch_buf_wr_0_l                     /* <ep1> */,
      input  ch_reverse_h                      /* <bd1> */,
      input  ch_t0_l                           /* <fs2> */,
      input  ch_t2_l                           /* <af1> */,
      input  clk_mb_00_h                       /* <cr2> */,
      input  con_ki10_paging_mode_l            /* <ek1> */,
      input  crc_buf_mb_sel_h                  /* <dt2> */,
      input  crc_cbus_out_hold_h               /* <fu2> */,
      input  crc_ch_buf_adr_0_h                /* <fp2> */,
      input  crc_ch_buf_adr_1_h                /* <fr2> */,
      input  crc_ch_buf_adr_2_h                /* <fp1> */,
      input  crc_ch_buf_adr_3_h                /* <de1> */,
      input  crc_ch_buf_adr_4_h                /* <dj1> */,
      input  crc_ch_buf_adr_5_h                /* <de2> */,
      input  crc_ch_buf_adr_6_h                /* <ae1> */,
      input  mb0_hold_in_h                     /* <ad2> */,
      input  mb1_hold_in_h                     /* <ad1> */,
      input  mb2_hold_in_h                     /* <aa1> */,
      input  mb3_hold_in_h                     /* <ac1> */,
      output mb_00_h                           /* <fd2> */,
      output mb_00to05_par_odd_h               /* <ds2> */,
      output mb_01_h                           /* <dr2> */,
      output mb_02_h                           /* <dp2> */,
      output mb_03_h                           /* <dm1> */,
      output mb_04_h                           /* <dr1> */,
      output mb_05_h                           /* <dp1> */,
      output mb_18_h                           /* <av2> */,
      output mb_18to23_par_odd_h               /* <au2> */,
      output mb_19_h                           /* <ba1> */,
      output mb_20_h                           /* <cd2> */,
      output mb_21_h                           /* <cd1> */,
      output mb_22_h                           /* <ca1> */,
      output mb_23_h                           /* <bv2> */,
      input  mb_in_sel_1_h                     /* <ej1> */,
      input  mb_in_sel_2_h                     /* <el1> */,
      input  mb_in_sel_4_h                     /* <ep2> */,
      input  mb_sel_1_en_h                     /* <fr1> */,
      input  mb_sel_2_en_h                     /* <ft2> */,
      input  mb_sel_hold_h                     /* <fv2> */,
      input  mem_data_in_00_h                  /* <em2> */,
      input  mem_data_in_01_h                  /* <ej2> */,
      input  mem_data_in_02_h                  /* <ea1> */,
      input  mem_data_in_03_h                  /* <dv2> */,
      input  mem_data_in_04_h                  /* <cp1> */,
      input  mem_data_in_05_h                  /* <cm1> */,
      input  mem_data_in_18_h                  /* <dj2> */,
      input  mem_data_in_19_h                  /* <df2> */,
      input  mem_data_in_20_h                  /* <bm1> */,
      input  mem_data_in_21_h                  /* <bk2> */,
      input  mem_data_in_22_h                  /* <bl2> */,
      input  mem_data_in_23_h                  /* <bk1> */,
      input  mem_to_c_en_l                     /* <ed2> */,
      input  mem_to_c_sel_1_h                  /* <ed1> */,
      input  mem_to_c_sel_2_h                  /* <ds1> */,
      output mem_to_cache_00_h                 /* <en1> */,
      output mem_to_cache_01_h                 /* <ef2> */,
      output mem_to_cache_02_h                 /* <ec1> */,
      output mem_to_cache_03_h                 /* <du2> */,
      output mem_to_cache_04_h                 /* <cf2> */,
      output mem_to_cache_05_h                 /* <cc1> */,
      output mem_to_cache_18_h                 /* <cs1> */,
      output mem_to_cache_19_h                 /* <dd1> */,
      output mem_to_cache_20_h                 /* <br2> */,
      output mem_to_cache_21_h                 /* <bf2> */,
      output mem_to_cache_22_h                 /* <bp2> */,
      output mem_to_cache_23_h                 /* <bh2> */,
      input  nxm_any_l                         /* <fs1> */,
      output pt_in_00_h                        /* <fe1> */,
      output pt_in_01_h                        /* <fe2> */,
      output pt_in_02_h                        /* <fa1> */,
      output pt_in_03_h                        /* <et2> */,
      output pt_in_04_h                        /* <dc1> */,
      output pt_in_05_h                        /* <da1> */,
      output pt_in_18_h                        /* <cu2> */,
      output pt_in_19_h                        /* <ct2> */,
      output pt_in_20_h                        /* <ce1> */,
      output pt_in_21_h                        /* <ce2> */,
      output pt_in_22_h                        /* <bs1> */,
      output pt_in_23_h                        /* <bt2> */
);

`include "mb016nets.svh"

endmodule	// mb016
