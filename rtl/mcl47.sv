module mcl47(
  /* <fs1> */  input ad_01_h,
  /* <fr1> */  input ad_02_h,
  /* <fp1> */  input ad_03_h,
  /* <fs2> */  input ad_04_a_h,
  /* <dr1> */  input ad_05_a_h,
  /* <au2> */  input ad_06_a_l,
  /* <ep1> */  input ad_06to11Eq0_l,
  /* <fr2> */  input ad_07_h,
  /* <dp2> */  input ad_08_h,
  /* <fp2> */  input ad_09_h,
  /* <fe2> */  input ad_10_a_h,
  /* <fh2> */  input ad_11_a_h,
  /* <fn1> */  input ad_12_a_h,
  /* <al2> */  input apr3_fetch_comp_h,
  /* <el2> */  input apr3_fm_extended_h,
  /* <ac1> */  input apr3_read_comp_h,
  /* <ak2> */  input apr3_user_comp_h,
  /* <al1> */  input apr3_write_comp_h,
  /* <ea1> */  input apr4_ac_09_l,
  /* <ds1> */  input apr4_ac_10_l,
  /* <dt2> */  input apr4_ac_11_l,
  /* <dv2> */  input apr4_ac_12_l,
  /* <et2> */  input clk3_ebox_sync_b_l,
  /* <cr2> */  input clk3_mcl_h,
  /* <fd2> */  input con_cache_load_en_h,
  /* <ep2> */  input con_condSlload_vma_held_h,
  /* <ce1> */  input con_condSlsel_vma_l,
  /* <dm1> */  input con_load_access_cond_h,
  /* <du2> */  input con_load_spec_instr_l,
  /* <dp1> */  input con_pi_cycle_a_h,
  /* <fl2> */  input con_trap_en_h,
  /* <cr1> */  input cram_Nr_00_b_h,
  /* <cs1> */  input cram_Nr_01_b_h,
  /* <cp1> */  input cram_Nr_02_b_h,
  /* <cp2> */  input cram_Nr_03_b_h,
  /* <dn1> */  input cram_Nr_04_b_h,
  /* <cv2> */  input cram_Nr_05_b_h,
  /* <ff2> */  input cram_Nr_07_b_h,
  /* <ft2> */  input cram_Nr_08_b_h,
  /* <ev2> */  input cram_mem_00_h,
  /* <es2> */  input cram_mem_01_h,
  /* <fj2> */  input cram_mem_02_h,
  /* <fk2> */  input cram_mem_03_h,
  /* <dm2> */  input cram_shNgarmm_sel_1_a_l,
  /* <ed1> */  input cram_shNgarmm_sel_2_a_l,
  /* <ef2> */  input cram_vma_sel_1_h,
  /* <eh2> */  input cram_vma_sel_2_h,
  /* <ec1> */  input ctl3_diag_force_extend_h,
  /* <df2> */  input diag_04_a_h,
  /* <de2> */  input diag_05_a_h,
  /* <dd2> */  input diag_06_a_h,
  /* <ef1> */  input diag_read_func_10x_l,
  /* <fm2> */  input dram_a_00_h,
  /* <fm1> */  input dram_a_01_h,
  /* <fu2> */  input dram_a_02_h,
  /* <fl1> */  input dram_b_01_h,
  /* <dj1> */ output ebus_d18_e_h,
  /* <df1> */ output ebus_d19_e_h,
  /* <de1> */ output ebus_d20_e_h,
  /* <dd1> */ output ebus_d21_e_h,
  /* <dc1> */ output ebus_d22_e_h,
  /* <da1> */ output ebus_d23_e_h,
  /* <ds2> */  input ir_jrst_0Cm_l,
  /* <dl1> */  input ir_test_satisfied_l,
  /* <ar1> */ output mcl1_load_vma_held_l,
  /* <as2> */ output mcl1_memSlarl_ind_h,
  /* <er2> */ output mcl1_memSlreg_func_l,
  /* <as1> */ output mcl1_req_en_l,
  /* <af2> */ output mcl2_vma_exec_h,
  /* <an1> */ output mcl2_vma_extended_l,
  /* <bh2> */ output mcl2_vma_pause_h,
  /* <at2> */ output mcl2_vma_pause_l,
  /* <ar2> */ output mcl2_vma_read_l,
  /* <bf2> */ output mcl2_vma_read_or_write_l,
  /* <aj2> */ output mcl2_vma_user_l,
  /* <ap2> */ output mcl2_vma_write_l,
  /* <be1> */ output mcl3_page_address_cond_h,
  /* <af1> */ output mcl3_page_ill_entry_h,
  /* <ad2> */ output mcl3_page_ill_entry_l,
  /* <ah2> */ output mcl3_page_test_private_h,
  /* <ck2> */ output mcl4_load_vma_context_l,
  /* <dk2> */ output mcl4_short_stack_h,
  /* <cm1> */ output mcl4_vmaGETSad_h,
  /* <cn1> */ output mcl4_vma_inc_h,
  /* <dk1> */ output mcl4_vma_prev_en_h,
  /* <bp2> */ output mcl4_vmax_sel_1_h,
  /* <bn1> */ output mcl4_vmax_sel_2_h,
  /* <bs2> */ output mcl4_xr_previous_h,
  /* <cj1> */ output mcl5_18_bit_ea_h,
  /* <cl2> */ output mcl5_23_bit_ea_h,
  /* <ee1> */ output mcl5_adr_err_h,
  /* <eu2> */ output mcl5_mbox_cyc_req_l,
  /* <ch2> */ output mcl5_vma_adr_err_h,
  /* <bm1> */ output mcl5_vmax_en_l,
  /* <ca1> */ output mcl6_ebox_cache_l,
  /* <dl2> */ output mcl6_ebox_map_h,
  /* <cd2> */ output mcl6_ebox_map_l,
  /* <cc1> */ output mcl6_ebox_may_be_paged_l,
  /* <cu2> */ output mcl6_page_uebr_ref_a_h,
  /* <aj1> */ output mcl6_page_uebr_ref_h,
  /* <ap1> */ output mcl6_paged_fetch_l,
  /* <ek1> */ output mcl6_pc_section_0_h,
  /* <ct2> */ output mcl6_vma_ept_h,
  /* <bd1> */ output mcl6_vma_fetch_h,
  /* <ak1> */ output mcl6_vma_upt_h,
  /* <bc1> */ output mcl_load_ar_h,
  /* <ba1> */ output mcl_load_arx_h,
  /* <ej2> */ output mcl_load_vma_h,
  /* <ck1> */ output mcl_mbox_cyc_req_h,
  /* <fv2> */ output mcl_skip_satisfied_h,
  /* <av2> */ output mcl_store_ar_l,
  /* <aa1> */ output mcl_vma_fetch_l,
  /* <cj2> */ output mcl_vma_section_0_h,
  /* <am1> */ output mcl_vma_user_h,
  /* <ee2> */  input mr_reset_04_h,
  /* <bm2> */  input scd4_cry0_h,
  /* <bl2> */  input scd4_cry1_h,
  /* <cd1> */  input scd4_div_chk_h,
  /* <bk2> */  input scd4_fov_h,
  /* <bj2> */  input scd4_fpd_h,
  /* <cf2> */  input scd4_fxu_h,
  /* <dr2> */  input scd4_pcp_h,
  /* <dh2> */  input scd4_trap_req_1_h,
  /* <cs2> */  input scd4_trap_req_2_h,
  /* <bs1> */  input scd5_adr_brk_inh_h,
  /* <ae2> */  input scd5_adr_brk_prevent_h,
  /* <ad1> */  input scd5_private_instr_l,
  /* <bt2> */  input scd5_public_a_h,
  /* <bu2> */  input scd5_user_a_h,
  /* <bv2> */  input scd5_user_iot_a_h,
  /* <bp1> */  input vma1_vma_section_0_l,
  /* <am2> */  input vma2_vma_12_h,
  /* <ae1> */  input vma3_match_13to35_l,
  /* <el1> */  input vma3_pc_section_0_l,
  /* <ej1> */  input vma4_pcs_section_0_l,
  /* <be2> */ output vma_held_or_pc_01_h,
  /* <bk1> */ output vma_held_or_pc_02_h,
  /* <bj1> */ output vma_held_or_pc_03_h,
  /* <br1> */ output vma_held_or_pc_04_h,
  /* <cl1> */ output vma_held_or_pc_05_h,
  /* <cf1> */ output vma_held_or_pc_06_h,
  /* <bd2> */ output vma_held_or_pc_07_h,
  /* <bl1> */ output vma_held_or_pc_08_h,
  /* <bf1> */ output vma_held_or_pc_09_h,
  /* <br2> */ output vma_held_or_pc_10_h,
  /* <cm2> */ output vma_held_or_pc_11_h,
  /* <ce2> */ output vma_held_or_pc_12_h
);

`include "mcl47.svh"

endmodule	// mcl47
