module con35(
      input  apr_fm_36_h                       /* <fp1> */,
      input  clk_con_h                         /* <cr2> */,
      input  clk_ebox_sync_a_l                 /* <ba1> */,
      input  clk_mb_xfer_h                     /* <fk1> */,
      input  clk_page_error_h                  /* <ap1> */,
      input  clk_sbr_call_h                    /* <fn1> */,
      output con1_condSl024_l                  /* <ck2> */,
      output con2_long_en_l                    /* <dm1> */,
      output con3_Nr_func_010_h                /* <be2> */,
      output con3_Nr_func_011_h                /* <bd1> */,
      output con3_Nr_func_04x_l                /* <ek1> */,
      output con3_Nr_func_05x_l                /* <ek2> */,
      output con4_spec_08_h                    /* <fd2> */,
      output con_ar_36_h                       /* <ak2> */,
      output con_ar_36_l                       /* <ev2> */,
      output con_ar_from_ebus_h                /* <ef1> */,
      output con_ar_loaded_l                   /* <el2> */,
      output con_arx_36_h                      /* <aj2> */,
      output con_arx_loaded_l                  /* <ej1> */,
      output con_cache_load_en_h               /* <ar1> */,
      output con_cache_look_en_l               /* <ae1> */,
      output con_clr_private_instr_h           /* <bk1> */,
      output con_condSl026_l                   /* <cj1> */,
      output con_condSl027_l                   /* <cj2> */,
      output con_condSlad_flags_h              /* <ce1> */,
      output con_condSldiag_func_l             /* <ee1> */,
      output con_condSlebus_ctl_l              /* <du2> */,
      output con_condSlfe_shrt_h               /* <cf2> */,
      output con_condSlload_vma_held_h         /* <cn1> */,
      output con_condSlmbox_ctl_l              /* <cp1> */,
      output con_condSlpcfGETSNr_h             /* <cf1> */,
      output con_condSlsel_vma_h               /* <cd1> */,
      output con_condSlsel_vma_l               /* <cp2> */,
      output con_condSlvmaGETSNr_h             /* <ct2> */,
      output con_cond_adr_10_h                 /* <bm2> */,
      output con_cond_en_00to07_l              /* <cm2> */,
      output con_cond_en_30to37_l              /* <cm1> */,
      output con_cond_instr_abort_h            /* <dc1> */,
      output con_cono_200000_h                 /* <fv2> */,
      output con_cono_apr_l                    /* <dd1> */,
      output con_cono_pi_l                     /* <aj1> */,
      output con_datao_apr_l                   /* <as2> */,
      output con_delay_req_h                   /* <al2> */,
      output con_ebox_halted_h                 /* <en1> */,
      output con_ebus_rel_h                    /* <bt2> */,
      output con_fm_write_00to17_l             /* <fe1> */,
      output con_fm_write_18to35_l             /* <ed1> */,
      output con_fm_write_par_l                /* <ff1> */,
      output con_fm_xfer_h                     /* <fl1> */,
      output con_fm_xfer_l                     /* <fj1> */,
      output con_ki10_paging_mode_h            /* <aa1> */,
      output con_ki10_paging_mode_l            /* <bl2> */,
      output con_load_ac_blocks_l              /* <ej2> */,
      output con_load_access_cond_h            /* <br2> */,
      output con_load_dram_h                   /* <bp2> */,
      output con_load_dram_l                   /* <eu2> */,
      output con_load_ir_l                     /* <bs2> */,
      output con_load_prev_context_l           /* <eh2> */,
      output con_load_spec_instr_l             /* <et2> */,
      output con_mbox_wait_l                   /* <fh2> */,
      output con_nicond_07_h                   /* <bj1> */,
      output con_nicond_08_h                   /* <bh2> */,
      output con_nicond_09_h                   /* <bf1> */,
      output con_nicond_trap_en_h              /* <bj2> */,
      output con_pcPl1_inh_h                   /* <fa1> */,
      output con_pcPl1_inh_l                   /* <bk2> */,
      output con_pi_cycle_a_h                  /* <es1> */,
      output con_pi_cycle_a_l                  /* <es2> */,
      output con_pi_cycle_b_h                  /* <ep2> */,
      output con_pi_cycle_b_l                  /* <er2> */,
      output con_pi_disable_l                  /* <er1> */,
      output con_pi_dismiss_l                  /* <fk2> */,
      output con_run_h                         /* <bs1> */,
      output con_sel_clr_h                     /* <de1> */,
      output con_sel_dis_h                     /* <dh2> */,
      output con_sel_en_l                      /* <df2> */,
      output con_sel_set_l                     /* <dd2> */,
      output con_set_pih_l                     /* <fe2> */,
      output con_skip_en_40to47_l              /* <cl2> */,
      output con_skip_en_50to57_l              /* <ck1> */,
      output con_sr_00_h                       /* <be1> */,
      output con_sr_01_h                       /* <cr1> */,
      output con_sr_02_h                       /* <cs1> */,
      output con_sr_03_h                       /* <cs2> */,
      output con_trap_en_a_h                   /* <ac1> */,
      output con_trap_en_h                     /* <da1> */,
      output con_ucode_state_01_h              /* <ef2> */,
      output con_ucode_state_03_h              /* <ee2> */,
      output con_ucode_state_07_h              /* <ed2> */,
      output con_vma_sel_1_l                   /* <ar2> */,
      output con_vma_sel_2_l                   /* <an1> */,
      output con_wr_even_par_adr_h             /* <am2> */,
      output con_wr_even_par_dir_l             /* <af2> */,
      input  cram_Nr_00_e_h                    /* <ec1> */,
      input  cram_Nr_01_e_h                    /* <ea1> */,
      input  cram_Nr_02_e_h                    /* <el1> */,
      input  cram_Nr_03_e_h                    /* <dt2> */,
      input  cram_Nr_04_e_h                    /* <dn1> */,
      input  cram_Nr_05_e_h                    /* <em1> */,
      input  cram_Nr_06_e_h                    /* <dk1> */,
      input  cram_Nr_07_e_h                    /* <bc1> */,
      input  cram_Nr_08_e_h                    /* <dp1> */,
      input  cram_cond_00_h                    /* <ah2> */,
      input  cram_cond_01_h                    /* <af1> */,
      input  cram_cond_02_h                    /* <ak1> */,
      input  cram_cond_03_h                    /* <ad2> */,
      input  cram_cond_04_h                    /* <ad1> */,
      input  cram_cond_05_h                    /* <ae2> */,
      input  cram_mem_02_a_l                   /* <fl2> */,
      input  csh_par_bit_a_h                   /* <fr1> */,
      input  csh_par_bit_b_h                   /* <fp2> */,
      input  ctl_console_control_h             /* <em2> */,
      input  ctl_dispSlnicond_h                /* <dj2> */,
      input  ctl_ebus_xfer_l                   /* <fm1> */,
      input  ctl_specSlflag_ctl_l              /* <fd1> */,
      input  ctl_specSlsave_flags_l            /* <fc1> */,
      input  diag_06_a_h                       /* <at2> */,
      input  diag_control_func_01x_l           /* <ds2> */,
      output ebus_d18_e_h                      /* <ca1> */,
      output ebus_d19_e_h                      /* <cd2> */,
      output ebus_d20_e_h                      /* <ce2> */,
      output ebus_d21_e_h                      /* <cc1> */,
      output ebus_d22_e_h                      /* <cu2> */,
      output ebus_d23_e_h                      /* <cv2> */,
      output ebus_d24_e_h                      /* <dv2> */,
      input  ebus_ds04_e_h                     /* <dr1> */,
      input  ebus_ds05_e_h                     /* <dp2> */,
      input  ebus_ds06_e_h                     /* <dr2> */,
      input  ebus_parity_active_e_h            /* <fu2> */,
      input  ebus_parity_e_h                   /* <fm2> */,
      input  ir_IO_legal_h                     /* <ds1> */,
      input  mbz1_rdNgpseNgwr_ref_l            /* <ap2> */,
      input  mcl_load_ar_h                     /* <ft2> */,
      input  mcl_load_vma_h                    /* <al1> */,
      input  mcl_mbox_cyc_req_h                /* <ep1> */,
      input  mcl_skip_satisfied_h              /* <ff2> */,
      input  mcl_store_ar_l                    /* <fr2> */,
      input  mcl_vma_fetch_l                   /* <fs2> */,
      input  mcl_vma_section_0_h               /* <cl1> */,
      input  mr_reset_04_h                     /* <df1> */,
      input  mtr_interrupt_req_h               /* <dk2> */,
      input  pi2_ext_tran_rec_h                /* <bu2> */,
      input  pi2_ready_h                       /* <dj1> */,
      input  pi5_ebus_cp_grant_h               /* <bv2> */,
      input  scd_public_a_l                    /* <as1> */,
      input  scd_user_a_l                      /* <dl2> */,
      input  scd_user_iot_a_l                  /* <dl1> */,
      input  vma_ac_ref_l                      /* <de2> */
);

`include "con35nets.svh"

endmodule	// con35
