module pma29(
      input  apr6_ebox_cca_h                   /* <ac1> */,
      input  apr6_ebox_ebr_h                   /* <aa1> */,
      input  apr6_ebox_ubr_h                   /* <fd2> */,
      input  apr_ebox_era_h                    /* <fe2> */,
      input  cam_14_h                          /* <bv2> */,
      input  cam_15_h                          /* <bt2> */,
      input  cam_16_h                          /* <ck2> */,
      input  cam_17_h                          /* <ce2> */,
      input  cam_18_h                          /* <cu2> */,
      input  cam_19_h                          /* <cs2> */,
      input  cam_20_h                          /* <ej1> */,
      input  cam_21_h                          /* <ej2> */,
      input  cam_22_h                          /* <ff1> */,
      input  cam_23_h                          /* <fc1> */,
      input  cam_24_h                          /* <fm2> */,
      input  cam_25_h                          /* <fk2> */,
      input  cam_26_h                          /* <fv2> */,
      input  ccl_chan_ept_h                    /* <ec1> */,
      input  ccw_cha_14_h                      /* <bc1> */,
      input  ccw_cha_15_h                      /* <bl2> */,
      input  ccw_cha_16_h                      /* <bu2> */,
      input  ccw_cha_17_h                      /* <ba1> */,
      input  ccw_cha_18_h                      /* <aj1> */,
      input  ccw_cha_19_h                      /* <bm1> */,
      input  ccw_cha_20_h                      /* <al1> */,
      input  ccw_cha_21_h                      /* <ak2> */,
      input  ccw_cha_22_h                      /* <aj2> */,
      input  ccw_cha_23_h                      /* <al2> */,
      input  ccw_cha_24_h                      /* <be1> */,
      input  ccw_cha_25_h                      /* <bd2> */,
      input  ccw_cha_26_h                      /* <br2> */,
      input  ccw_cha_27_h                      /* <fu2> */,
      input  ccw_cha_28_h                      /* <bj2> */,
      input  ccw_cha_29_h                      /* <cl1> */,
      input  ccw_cha_30_h                      /* <dj2> */,
      input  ccw_cha_31_h                      /* <er2> */,
      input  ccw_cha_32_h                      /* <fl1> */,
      input  ccw_cha_33_h                      /* <fr1> */,
      input  clk1_pma_h                        /* <cr2> */,
      input  csh1_cca_req_grant_h              /* <fn1> */,
      input  csh1_chan_req_grant_h             /* <fp2> */,
      input  csh1_ebox_cca_grant_h             /* <cn1> */,
      input  csh1_ebox_era_grant_h             /* <cc1> */,
      input  csh1_ebox_req_grant_a_l           /* <fk1> */,
      input  csh1_ebox_req_grant_h             /* <fs1> */,
      input  csh1_ready_to_go_l                /* <ft2> */,
      input  csh5_page_refill_t4_l             /* <fd1> */,
      output ebox_paged_h                      /* <ee2> */,
      input  hold_era_h                        /* <dj1> */,
      input  mbx1_cca_all_pages_cyc_h          /* <em2> */,
      input  mbx1_cca_sel_1_h                  /* <ff2> */,
      input  mbx1_cca_sel_2_h                  /* <fm1> */,
      input  mbx1_ebox_load_reg_h              /* <ad1> */,
      input  mbx2_cache_to_mb_34_h             /* <fl2> */,
      input  mbx2_cache_to_mb_35_h             /* <fe1> */,
      input  mbx4_writeback_t2_l               /* <ep2> */,
      input  mcl2_vma_user_l                   /* <ev2> */,
      input  mcl6_ebox_may_be_paged_l          /* <ek2> */,
      input  mcl6_vma_ept_h                    /* <ef2> */,
      input  mcl6_vma_upt_h                    /* <fa1> */,
      input  pag1_pt_14_a_h                    /* <bs1> */,
      input  pag1_pt_15_a_h                    /* <bs2> */,
      input  pag1_pt_16_a_h                    /* <br1> */,
      input  pag1_pt_17_a_h                    /* <at2> */,
      input  pag2_pt_18_a_h                    /* <as1> */,
      input  pag2_pt_19_a_h                    /* <ar2> */,
      input  pag2_pt_20_a_h                    /* <bp1> */,
      input  pag2_pt_21_a_h                    /* <bp2> */,
      input  pag2_pt_22_a_h                    /* <bn1> */,
      input  pag2_pt_23_a_h                    /* <cj2> */,
      input  pag2_pt_24_a_h                    /* <cj1> */,
      input  pag2_pt_25_a_h                    /* <ck1> */,
      input  pag2_pt_26_a_h                    /* <bd1> */,
      output pma2_cca_cry_out_l                /* <bf1> */,
      output pma3_pa_14_h                      /* <ds2> */,
      output pma3_pa_15_h                      /* <ds1> */,
      output pma3_pa_16_h                      /* <dr2> */,
      output pma3_pa_17_h                      /* <dm2> */,
      output pma3_pa_18_h                      /* <cm2> */,
      output pma3_pa_19_h                      /* <cm1> */,
      output pma3_pa_20_h                      /* <cf2> */,
      output pma3_pa_21_h                      /* <cd2> */,
      output pma3_pa_22_h                      /* <cd1> */,
      output pma3_pa_23_h                      /* <ce1> */,
      output pma3_pa_24_h                      /* <dd2> */,
      output pma3_pa_25_h                      /* <dd1> */,
      output pma3_pa_26_h                      /* <de1> */,
      output pma3_pa_27_h                      /* <de2> */,
      output pma3_pa_28_h                      /* <dt2> */,
      output pma3_pa_29_h                      /* <ea1> */,
      output pma3_pa_30_h                      /* <dp1> */,
      output pma3_pa_31_h                      /* <dm1> */,
      output pma4_34_b_h                       /* <er1> */,
      output pma4_34_b_l                       /* <es1> */,
      output pma4_35_b_h                       /* <ep1> */,
      output pma4_35_b_l                       /* <em1> */,
      output pma4_adr_par_h                    /* <bk2> */,
      output pma4_pa_32_h                      /* <bk1> */,
      output pma4_pa_33_h                      /* <bj1> */,
      output pma4_pa_34_h                      /* <ee1> */,
      output pma4_pa_35_h                      /* <ef1> */,
      output pma5_csh_ebox_cyc_l               /* <dk2> */,
      output pma5_csh_writeback_cyc_h          /* <el2> */,
      output pma5_csh_writeback_cyc_l          /* <eu2> */,
      output pma5_cyc_type_hold_h              /* <fr2> */,
      output pma5_ebox_paged_l                 /* <ed1> */,
      output pma5_page_refill_cyc_l            /* <dl2> */,
      output pma_14_h                          /* <cr1> */,
      output pma_14to26_par_h                  /* <an1> */,
      output pma_15_h                          /* <cs1> */,
      output pma_16_h                          /* <da1> */,
      output pma_17_h                          /* <dc1> */,
      output pma_18_h                          /* <ct2> */,
      output pma_19_h                          /* <cv2> */,
      output pma_20_h                          /* <cf1> */,
      output pma_21_h                          /* <ch2> */,
      output pma_22_h                          /* <bm2> */,
      output pma_23_h                          /* <ca1> */,
      output pma_24_h                          /* <dk1> */,
      output pma_25_h                          /* <dl1> */,
      output pma_26_h                          /* <df2> */,
      output pma_27_h                          /* <df1> */,
      output pma_28_h                          /* <du2> */,
      output pma_29_h                          /* <dv2> */,
      output pma_30_h                          /* <dn1> */,
      output pma_31_h                          /* <dp2> */,
      output pma_32_h                          /* <el1> */,
      output pma_33_h                          /* <ek1> */,
      output pma_34_h                          /* <as2> */,
      output pma_35_h                          /* <be2> */,
      input  sbus_adr_34_h                     /* <cp1> */,
      input  sbus_adr_35_h                     /* <cp2> */,
      input  vma2_vma_14_a_h                   /* <ap2> */,
      input  vma2_vma_15_a_h                   /* <ap1> */,
      input  vma2_vma_16_a_h                   /* <am2> */,
      input  vma2_vma_17_a_h                   /* <am1> */,
      input  vma2_vma_21_a_h                   /* <ak1> */,
      input  vma2_vma_22_a_h                   /* <af1> */,
      input  vma2_vma_23_a_h                   /* <ae1> */,
      input  vma2_vma_24_a_h                   /* <av2> */,
      input  vma2_vma_25_a_h                   /* <au2> */,
      input  vma2_vma_26_a_h                   /* <ar1> */,
      input  vma2_vma_27_h                     /* <fs2> */,
      input  vma2_vma_28_h                     /* <bf2> */,
      input  vma2_vma_29_h                     /* <bl1> */,
      input  vma2_vma_30_h                     /* <cl2> */,
      input  vma2_vma_31_h                     /* <ed2> */,
      input  vma2_vma_32_h                     /* <fj1> */,
      input  vma2_vma_33_h                     /* <fp1> */,
      input  vma2_vma_34_h                     /* <fj2> */,
      input  vma2_vma_35_h                     /* <es2> */,
      input  vma_18_a_h                        /* <af2> */,
      input  vma_19_a_h                        /* <ae2> */,
      input  vma_20_a_h                        /* <ad2> */
);

`include "pma29nets.svh"

endmodule	// pma29
