module edp43(
  /* <cp2> */  input ad_16_h,
  /* <el2> */  input ad_17_h,
  /* <ck1> */ output ad_18_a_h,
  /* <cn1> */ output ad_18_a_l,
  /* <ep2> */ output ad_18_h,
  /* <at2> */ output ad_18to23Eq0_l,
  /* <dl1> */ output ad_19_h,
  /* <dr2> */ output ad_20_h,
  /* <dr1> */ output ad_21_h,
  /* <cf2> */ output ad_22_a_h,
  /* <cp1> */ output ad_22_h,
  /* <ce1> */ output ad_23_a_h,
  /* <el1> */ output ad_23_h,
  /* <ep1> */  input ad_24_h,
  /* <am1> */ output ad_cg_18_h,
  /* <am2> */ output ad_cg_20_h,
  /* <aj1> */ output ad_cp_18_h,
  /* <af1> */ output ad_cp_20_h,
  /* <cu2> */ output ad_cry_19_h,
  /* <ct2> */ output ad_cry_19_l,
  /* <al1> */  input ad_cry_24_h,
  /* <cv2> */ output ad_ex_16_h,
  /* <cr1> */ output ad_ex_17_h,
  /* <cl2> */ output ad_overflow_18_l,
  /* <es2> */  input adx_17_h,
  /* <cf1> */ output adx_18_a_h,
  /* <cj2> */ output adx_18_h,
  /* <dk1> */ output adx_22_h,
  /* <es1> */ output adx_23_h,
  /* <cj1> */  input adx_24_h,
  /* <al2> */ output adx_cg_18_h,
  /* <ak2> */ output adx_cg_21_h,
  /* <ae1> */ output adx_cp_18_h,
  /* <af2> */ output adx_cp_21_h,
  /* <ak1> */  input adx_cry_24_h,
  /* <fr2> */  input apr_fm_adr_10_h,
  /* <fp2> */  input apr_fm_adr_1_h,
  /* <fs1> */  input apr_fm_adr_2_h,
  /* <fn1> */  input apr_fm_adr_4_h,
  /* <fr1> */  input apr_fm_block_1_h,
  /* <fm1> */  input apr_fm_block_2_h,
  /* <fp1> */  input apr_fm_block_4_h,
  /* <fj2> */ output ar_18_a_h,
  /* <ft2> */ output ar_18_b_h,
  /* <fs2> */ output ar_18_c_h,
  /* <dm2> */ output ar_18_d_h,
  /* <bk2> */ output ar_18_h,
  /* <fc1> */ output ar_19_a_h,
  /* <fu2> */ output ar_19_b_h,
  /* <fv2> */ output ar_19_c_h,
  /* <bl2> */ output ar_19_h,
  /* <ff2> */ output ar_20_a_h,
  /* <cl1> */ output ar_20_b_h,
  /* <ch2> */ output ar_20_c_h,
  /* <eu2> */ output ar_21_a_h,
  /* <ck2> */ output ar_21_b_h,
  /* <cm1> */ output ar_21_c_h,
  /* <ev2> */ output ar_22_a_h,
  /* <fk1> */ output ar_22_b_h,
  /* <fk2> */ output ar_22_c_h,
  /* <et2> */ output ar_23_a_h,
  /* <fl2> */ output ar_23_b_h,
  /* <fl1> */ output ar_23_c_h,
  /* <bk1> */  input ar_24_h,
  /* <bl1> */  input ar_25_h,
  /* <em2> */  input armm_18_h,
  /* <ea1> */  input armm_19_h,
  /* <ee1> */  input armm_20_h,
  /* <dd2> */  input armm_21_h,
  /* <de1> */  input armm_22_h,
  /* <ef2> */  input armm_23_h,
  /* <as2> */ output arx_18_a_h,
  /* <br2> */ output arx_18_b_h,
  /* <ej2> */ output arx_18_h,
  /* <as1> */ output arx_19_a_h,
  /* <cm2> */ output arx_19_b_h,
  /* <bd2> */ output arx_19_h,
  /* <dc1> */ output arx_20_h,
  /* <aj2> */ output arx_21_h,
  /* <ac1> */ output arx_22_h,
  /* <aa1> */ output arx_23_h,
  /* <ej1> */  input arx_24_h,
  /* <bd1> */  input arx_25_h,
  /* <bm2> */ output br_18_a_h,
  /* <bm1> */  input br_24_a_h,
  /* <be2> */ output brx_18_h,
  /* <be1> */  input brx_24_h,
  /* <em1> */  input cache_data_18_b_h,
  /* <ed2> */  input cache_data_19_b_h,
  /* <ee2> */  input cache_data_20_b_h,
  /* <dd1> */  input cache_data_21_b_h,
  /* <dl2> */  input cache_data_22_b_h,
  /* <cc1> */  input cache_data_23_b_h,
  /* <cr2> */  input clk_edp_18_h,
  /* <ce2> */  input con_fm_write_18to35_l,
  /* <ar1> */  input cram_Nr_18_h,
  /* <ap1> */  input cram_Nr_19_h,
  /* <ba1> */  input cram_Nr_20_h,
  /* <ap2> */  input cram_Nr_21_h,
  /* <av2> */  input cram_Nr_22_h,
  /* <au2> */  input cram_Nr_23_h,
  /* <an1> */  input cram_ad_boole_18_h,
  /* <ad2> */  input cram_ad_sel_1_18_h,
  /* <ah2> */  input cram_ad_sel_2_18_h,
  /* <ae2> */  input cram_ad_sel_4_18_h,
  /* <ad1> */  input cram_ad_sel_8_18_h,
  /* <bn1> */  input cram_ada_dis_18_h,
  /* <bj1> */  input cram_ada_sel_1_18_h,
  /* <bf2> */  input cram_ada_sel_2_18_h,
  /* <bt2> */  input cram_adb_sel_1_18_h,
  /* <bt1> */  input cram_adb_sel_1_18_h,
  /* <bs1> */  input cram_adb_sel_2_18_h,
  /* <er1> */  input cram_arm_sel_4_a_h,
  /* <ff1> */  input cram_arxm_sel_4_06_h,
  /* <dj2> */  input cram_br_load_a_h,
  /* <ar2> */  input cram_brx_load_a_h,
  /* <fe2> */  input ctl_ad_to_ebus_r_h,
  /* <eh2> */  input ctl_arr_clr_h,
  /* <ek2> */  input ctl_arr_load_a_l,
  /* <dh2> */  input ctl_arr_load_b_l,
  /* <en1> */  input ctl_arr_sel_1_h,
  /* <ek1> */  input ctl_arr_sel_2_h,
  /* <br1> */  input ctl_arx_load_h,
  /* <fj1> */  input ctl_arxr_sel_1_h,
  /* <fd2> */  input ctl_arxr_sel_2_h,
  /* <bu2> */  input ctl_mq_sel_1_h,
  /* <bv2> */  input ctl_mq_sel_2_h,
  /* <dn1> */  input ctl_mqm_en_h,
  /* <dj1> */  input ctl_mqm_sel_1_h,
  /* <dm1> */  input ctl_mqm_sel_2_h,
  /* <fd1> */  input diag_04_a_h,
  /* <fa1> */  input diag_05_a_h,
  /* <fe1> */  input diag_06_a_h,
  /* <ef1> */  input diag_read_func_12x_h,
  /* <dv2> */ output ebus_d18_e_h,
  /* <ds2> */ output ebus_d19_e_h,
  /* <dt2> */ output ebus_d20_e_h,
  /* <dp1> */ output ebus_d21_e_h,
  /* <dp2> */ output ebus_d22_e_h,
  /* <du2> */ output ebus_d23_e_h,
  /* <fm2> */ output edp_fm_parity_18to23_h,
  /* <cs2> */  input mq_16_h,
  /* <cd2> */ output mq_18_h,
  /* <cs1> */ output mq_22_h,
  /* <df1> */ output mq_23_h,
  /* <cd1> */  input mq_24_h,
  /* <ed1> */  input sh_18_h,
  /* <ec1> */  input sh_19_h,
  /* <ds1> */  input sh_20_h,
  /* <da1> */  input sh_21_h,
  /* <de2> */  input sh_22_h,
  /* <ca1> */  input sh_23_h,
  /* <bj2> */  input vma_held_or_pc_18_h,
  /* <bh2> */  input vma_held_or_pc_19_h,
  /* <bf1> */  input vma_held_or_pc_20_h,
  /* <bp2> */  input vma_held_or_pc_21_h,
  /* <bp1> */  input vma_held_or_pc_22_h,
  /* <bc1> */  input vma_held_or_pc_23_h
);

`include "edp43.svh"

endmodule	// edp43
