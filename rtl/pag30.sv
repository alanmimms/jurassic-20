module pag30(
  /* <ej1> */  input apr5_wr_pt_sel_0_h,
  /* <ev2> */  input apr5_wr_pt_sel_1_h,
  /* <cv2> */  input apr5_wr_pt_sel_1_l,
  /* <ff2> */  input clk2_pt_dir_wr_l,
  /* <dh2> */  input clk2_pt_wr_l,
  /* <du2> */  input con_ki10_paging_mode_h,
  /* <bl2> */  input con_ki10_paging_mode_l,
  /* <en1> */  input csh1_pgrf_cyc_a_h,
  /* <dm1> */  input csh5_page_refill_t12_l,
  /* <fj1> */  input csh6_mbox_pt_dir_wr_l,
  /* <cs1> */  input csh6_page_fail_hold_l,
  /* <fm2> */  input csh6_page_refill_error_h,
  /* <dl1> */  input csh6_page_refill_error_l,
  /* <cf1> */  input csh_ebox_cyc_a_l,
  /* <be1> */  input mb_00to05_par_odd_h,
  /* <bf1> */  input mb_06to11_par_odd_h,
  /* <ak1> */  input mb_12to17_par_odd_h,
  /* <bd2> */  input mb_18to23_par_odd_h,
  /* <ba1> */  input mb_24to29_par_odd_h,
  /* <aj1> */  input mb_30to35_par_odd_h,
  /* <al2> */  input mb_par_h,
  /* <bc1> */ output mb_par_odd_h,
  /* <er1> */  input mb_sel_1_h,
  /* <cr2> */  input mb_sel_2_h,
  /* <ac1> */  input mcl2_vma_exec_h,
  /* <fj2> */  input mcl2_vma_write_l,
  /* <fs2> */  input mcl3_page_address_cond_h,
  /* <ef1> */  input mcl3_page_ill_entry_h,
  /* <ep1> */  input mcl3_page_ill_entry_l,
  /* <dl2> */  input mcl3_page_test_private_h,
  /* <el2> */  input mcl5_vma_adr_err_h,
  /* <ek1> */  input mcl6_page_uebr_ref_h,
  /* <cl2> */  input mcl_vma_user_h,
  /* <bs1> */ output pag1_pt_14_a_h,
  /* <bs2> */ output pag1_pt_15_a_h,
  /* <br1> */ output pag1_pt_16_a_h,
  /* <as2> */ output pag1_pt_17_a_h,
  /* <fd2> */ output pag1_pt_cache_l,
  /* <as1> */ output pag2_pt_18_a_h,
  /* <ar2> */ output pag2_pt_19_a_h,
  /* <bp1> */ output pag2_pt_20_a_h,
  /* <bp2> */ output pag2_pt_21_a_h,
  /* <bn1> */ output pag2_pt_22_a_h,
  /* <cj2> */ output pag2_pt_23_a_h,
  /* <cj1> */ output pag2_pt_24_a_h,
  /* <ck2> */ output pag2_pt_25_a_h,
  /* <bd1> */ output pag2_pt_26_a_h,
  /* <fp2> */ output pag4_page_fail_l,
  /* <fl2> */ output pag4_page_ok_l,
  /* <ct2> */ output pag4_page_refill_l,
  /* <eh2> */ output pag4_pf_ebox_handle_h,
  /* <bk2> */ output pag_mb_00to17_par_h,
  /* <bj2> */ output pag_mb_18to35_par_h,
  /* <cu2> */ output paged_ref_h,
  /* <fr1> */ output pf_hold_01_in_h,
  /* <fd1> */ output pf_hold_02_in_h,
  /* <ft2> */ output pf_hold_03_in_h,
  /* <fp1> */ output pf_hold_04_in_h,
  /* <fn1> */ output pf_hold_05_in_h,
  /* <ds2> */  input pma3_pa_14_h,
  /* <ds1> */  input pma3_pa_15_h,
  /* <dr2> */  input pma3_pa_16_h,
  /* <dm2> */  input pma3_pa_17_h,
  /* <cm2> */  input pma3_pa_18_h,
  /* <cm1> */  input pma3_pa_19_h,
  /* <cf2> */  input pma3_pa_20_h,
  /* <cd2> */  input pma3_pa_21_h,
  /* <cd1> */  input pma3_pa_22_h,
  /* <ce2> */  input pma3_pa_23_h,
  /* <dd2> */  input pma3_pa_24_h,
  /* <dd1> */  input pma3_pa_25_h,
  /* <de1> */  input pma3_pa_26_h,
  /* <ed1> */  input pma5_ebox_paged_l,
  /* <df1> */ output pt_14_b_h,
  /* <de2> */ output pt_15_b_h,
  /* <cn1> */ output pt_16_b_h,
  /* <cr1> */ output pt_17_b_h,
  /* <dp2> */ output pt_18_b_h,
  /* <dp1> */ output pt_19_b_h,
  /* <dj2> */ output pt_20_b_h,
  /* <dk2> */ output pt_21_b_h,
  /* <es1> */ output pt_22_b_h,
  /* <er2> */ output pt_23_b_h,
  /* <ed2> */ output pt_24_b_h,
  /* <em2> */ output pt_25_b_h,
  /* <fl1> */ output pt_26_b_h,
  /* <dt2> */ output pt_access_h,
  /* <fa1> */ output pt_cache_h,
  /* <fr2> */  input pt_in_00_h,
  /* <fk1> */  input pt_in_01_h,
  /* <fk2> */  input pt_in_02_h,
  /* <fe1> */  input pt_in_03_h,
  /* <et2> */  input pt_in_04_h,
  /* <el1> */  input pt_in_05_h,
  /* <ec1> */  input pt_in_06_h,
  /* <dr1> */  input pt_in_07_h,
  /* <dk1> */  input pt_in_08_h,
  /* <cs2> */  input pt_in_09_h,
  /* <cl1> */  input pt_in_10_h,
  /* <ce1> */  input pt_in_11_h,
  /* <bm2> */  input pt_in_12_h,
  /* <be2> */  input pt_in_13_h,
  /* <av2> */  input pt_in_14_h,
  /* <at2> */  input pt_in_15_h,
  /* <ak2> */  input pt_in_16_h,
  /* <af1> */  input pt_in_17_h,
  /* <fs1> */  input pt_in_18_h,
  /* <ff1> */  input pt_in_19_h,
  /* <fh2> */  input pt_in_20_h,
  /* <fc1> */  input pt_in_21_h,
  /* <ep2> */  input pt_in_22_h,
  /* <ee1> */  input pt_in_23_h,
  /* <dv2> */  input pt_in_24_h,
  /* <dj1> */  input pt_in_26_h,
  /* <dn1> */  input pt_in_27_h,
  /* <cp2> */  input pt_in_27_h,
  /* <ck1> */  input pt_in_28_h,
  /* <ca1> */  input pt_in_29_h,
  /* <bm1> */  input pt_in_30_h,
  /* <bf2> */  input pt_in_31_h,
  /* <bj1> */  input pt_in_32_h,
  /* <au2> */  input pt_in_33_h,
  /* <al1> */  input pt_in_34_h,
  /* <af2> */  input pt_in_35_h,
  /* <fm1> */ output pt_match_l,
  /* <fe2> */ output pt_public_h,
  /* <fv2> */ output pt_software_h,
  /* <fu2> */ output pt_writable_h,
  /* <bl1> */  input sh_ar_par_odd_a_h,
  /* <ar1> */  input vma2_vma_13_a_h,
  /* <ap2> */  input vma2_vma_14_a_h,
  /* <ap1> */  input vma2_vma_15_a_h,
  /* <am2> */  input vma2_vma_16_a_h,
  /* <am1> */  input vma2_vma_17_a_h,
  /* <da1> */  input vma2_vma_17_h,
  /* <ae2> */  input vma2_vma_18_h,
  /* <df2> */  input vma2_vma_19_h,
  /* <dc1> */  input vma2_vma_20_h,
  /* <ae1> */  input vma2_vma_21_h,
  /* <ad1> */  input vma2_vma_22_h,
  /* <ad2> */  input vma2_vma_23_h,
  /* <cp1> */  input vma2_vma_24_h,
  /* <eu2> */  input vma2_vma_25_h,
  /* <ea1> */  input vma2_vma_26_h
);

`include "pag30nets.svh"

endmodule	// pag30
