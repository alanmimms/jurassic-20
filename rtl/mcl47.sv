module mcl47(
      input  ad_01_h                           /* <fs1> */,
      input  ad_02_h                           /* <fr1> */,
      input  ad_03_h                           /* <fp1> */,
      input  ad_04_a_h                         /* <fs2> */,
      input  ad_05_a_h                         /* <dr1> */,
      input  ad_06_a_l                         /* <au2> */,
      input  ad_06to11Eq0_l                    /* <ep1> */,
      input  ad_07_h                           /* <fr2> */,
      input  ad_08_h                           /* <dp2> */,
      input  ad_09_h                           /* <fp2> */,
      input  ad_10_a_h                         /* <fe2> */,
      input  ad_11_a_h                         /* <fh2> */,
      input  ad_12_a_h                         /* <fn1> */,
      input  apr3_fetch_comp_h                 /* <al2> */,
      input  apr3_fm_extended_h                /* <el2> */,
      input  apr3_read_comp_h                  /* <ac1> */,
      input  apr3_user_comp_h                  /* <ak2> */,
      input  apr3_write_comp_h                 /* <al1> */,
      input  apr4_ac_09_l                      /* <ea1> */,
      input  apr4_ac_10_l                      /* <ds1> */,
      input  apr4_ac_11_l                      /* <dt2> */,
      input  apr4_ac_12_l                      /* <dv2> */,
      input  clk3_ebox_sync_b_l                /* <et2> */,
      input  clk3_mcl_h                        /* <cr2> */,
      input  con_cache_load_en_h               /* <fd2> */,
      input  con_condSlload_vma_held_h         /* <ep2> */,
      input  con_condSlsel_vma_l               /* <ce1> */,
      input  con_load_access_cond_h            /* <dm1> */,
      input  con_load_spec_instr_l             /* <du2> */,
      input  con_pi_cycle_a_h                  /* <dp1> */,
      input  con_trap_en_h                     /* <fl2> */,
      input  cram_Nr_00_b_h                    /* <cr1> */,
      input  cram_Nr_01_b_h                    /* <cs1> */,
      input  cram_Nr_02_b_h                    /* <cp1> */,
      input  cram_Nr_03_b_h                    /* <cp2> */,
      input  cram_Nr_04_b_h                    /* <dn1> */,
      input  cram_Nr_05_b_h                    /* <cv2> */,
      input  cram_Nr_07_b_h                    /* <ff2> */,
      input  cram_Nr_08_b_h                    /* <ft2> */,
      input  cram_mem_00_h                     /* <ev2> */,
      input  cram_mem_01_h                     /* <es2> */,
      input  cram_mem_02_h                     /* <fj2> */,
      input  cram_mem_03_h                     /* <fk2> */,
      input  cram_shNgarmm_sel_1_a_l           /* <dm2> */,
      input  cram_shNgarmm_sel_2_a_l           /* <ed1> */,
      input  cram_vma_sel_1_h                  /* <ef2> */,
      input  cram_vma_sel_2_h                  /* <eh2> */,
      input  ctl1_specSlsp_mem_cycle_h         /* <ed2> */,
      input  ctl3_diag_force_extend_h          /* <ec1> */,
      input  diag_04_a_h                       /* <df2> */,
      input  diag_05_a_h                       /* <de2> */,
      input  diag_06_a_h                       /* <dd2> */,
      input  diag_read_func_10x_l              /* <ef1> */,
      input  dram_a_00_h                       /* <fm2> */,
      input  dram_a_01_h                       /* <fm1> */,
      input  dram_a_02_h                       /* <fu2> */,
      input  dram_b_01_h                       /* <fl1> */,
      output ebus_d18_e_h                      /* <dj1> */,
      output ebus_d19_e_h                      /* <df1> */,
      output ebus_d20_e_h                      /* <de1> */,
      output ebus_d21_e_h                      /* <dd1> */,
      output ebus_d22_e_h                      /* <dc1> */,
      output ebus_d23_e_h                      /* <da1> */,
      input  ir_jrst_0Cm_l                     /* <ds2> */,
      input  ir_test_satisfied_l               /* <dl1> */,
      output mcl1_load_vma_held_l              /* <ar1> */,
      output mcl1_memSlarl_ind_h               /* <as2> */,
      output mcl1_memSlreg_func_l              /* <er2> */,
      output mcl1_req_en_l                     /* <as1> */,
      output mcl2_vma_exec_h                   /* <af2> */,
      output mcl2_vma_extended_l               /* <an1> */,
      output mcl2_vma_pause_h                  /* <bh2> */,
      output mcl2_vma_pause_l                  /* <at2> */,
      output mcl2_vma_read_l                   /* <ar2> */,
      output mcl2_vma_read_or_write_l          /* <bf2> */,
      output mcl2_vma_user_l                   /* <aj2> */,
      output mcl2_vma_write_l                  /* <ap2> */,
      output mcl3_page_address_cond_h          /* <be1> */,
      output mcl3_page_ill_entry_h             /* <af1> */,
      output mcl3_page_ill_entry_l             /* <ad2> */,
      output mcl3_page_test_private_h          /* <ah2> */,
      output mcl4_load_vma_context_l           /* <ck2> */,
      output mcl4_short_stack_h                /* <dk2> */,
      output mcl4_vmaGETSad_h                  /* <cm1> */,
      output mcl4_vma_inc_h                    /* <cn1> */,
      output mcl4_vma_prev_en_h                /* <dk1> */,
      output mcl4_vmax_sel_1_h                 /* <bp2> */,
      output mcl4_vmax_sel_2_h                 /* <bn1> */,
      output mcl4_xr_previous_h                /* <bs2> */,
      output mcl5_18_bit_ea_h                  /* <cj1> */,
      output mcl5_23_bit_ea_h                  /* <cl2> */,
      output mcl5_adr_err_h                    /* <ee1> */,
      output mcl5_mbox_cyc_req_l               /* <eu2> */,
      output mcl5_vma_adr_err_h                /* <ch2> */,
      output mcl5_vmax_en_l                    /* <bm1> */,
      output mcl6_ebox_cache_l                 /* <ca1> */,
      output mcl6_ebox_map_h                   /* <dl2> */,
      output mcl6_ebox_map_l                   /* <cd2> */,
      output mcl6_ebox_may_be_paged_l          /* <cc1> */,
      output mcl6_page_uebr_ref_a_h            /* <cu2> */,
      output mcl6_page_uebr_ref_h              /* <aj1> */,
      output mcl6_paged_fetch_l                /* <ap1> */,
      output mcl6_pc_section_0_h               /* <ek1> */,
      output mcl6_vma_ept_h                    /* <ct2> */,
      output mcl6_vma_fetch_h                  /* <bd1> */,
      output mcl6_vma_upt_h                    /* <ak1> */,
      output mcl_load_ar_h                     /* <bc1> */,
      output mcl_load_arx_h                    /* <ba1> */,
      output mcl_load_vma_h                    /* <ej2> */,
      output mcl_mbox_cyc_req_h                /* <ck1> */,
      output mcl_skip_satisfied_h              /* <fv2> */,
      output mcl_store_ar_l                    /* <av2> */,
      output mcl_vma_fetch_l                   /* <aa1> */,
      output mcl_vma_section_0_h               /* <cj2> */,
      output mcl_vma_user_h                    /* <am1> */,
      input  mr_reset_04_h                     /* <ee2> */,
      input  scd4_cry0_h                       /* <bm2> */,
      input  scd4_cry1_h                       /* <bl2> */,
      input  scd4_div_chk_h                    /* <cd1> */,
      input  scd4_fov_h                        /* <bk2> */,
      input  scd4_fpd_h                        /* <bj2> */,
      input  scd4_fxu_h                        /* <cf2> */,
      input  scd4_pcp_h                        /* <dr2> */,
      input  scd4_trap_req_1_h                 /* <dh2> */,
      input  scd4_trap_req_2_h                 /* <cs2> */,
      input  scd5_adr_brk_inh_h                /* <bs1> */,
      input  scd5_adr_brk_prevent_h            /* <ae2> */,
      input  scd5_private_instr_l              /* <ad1> */,
      input  scd5_public_a_h                   /* <bt2> */,
      input  scd5_user_a_h                     /* <bu2> */,
      input  scd5_user_iot_a_h                 /* <bv2> */,
      input  vma1_vma_section_0_l              /* <bp1> */,
      input  vma2_vma_12_h                     /* <am2> */,
      input  vma3_match_13to35_l               /* <ae1> */,
      input  vma3_pc_section_0_l               /* <el1> */,
      input  vma4_pcs_section_0_l              /* <ej1> */,
      output vma_held_or_pc_01_h               /* <be2> */,
      output vma_held_or_pc_02_h               /* <bk1> */,
      output vma_held_or_pc_03_h               /* <bj1> */,
      output vma_held_or_pc_04_h               /* <br1> */,
      output vma_held_or_pc_05_h               /* <cl1> */,
      output vma_held_or_pc_06_h               /* <cf1> */,
      output vma_held_or_pc_07_h               /* <bd2> */,
      output vma_held_or_pc_08_h               /* <bl1> */,
      output vma_held_or_pc_09_h               /* <bf1> */,
      output vma_held_or_pc_10_h               /* <br2> */,
      output vma_held_or_pc_11_h               /* <cm2> */,
      output vma_held_or_pc_12_h               /* <ce2> */
);

`include "mcl47nets.svh"

endmodule	// mcl47
