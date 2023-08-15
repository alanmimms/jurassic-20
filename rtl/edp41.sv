module edp41(
  /* <cp2> */ input  ad_22_h,
  /* <el2> */ input  ad_23_h,
  /* <ck1> */ output ad_24_a_h,
  /* <cn1> */ output ad_24_a_l,
  /* <ep2> */ output ad_24_h,
  /* <at2> */ output ad_24to29Eq0_l,
  /* <dl1> */ output ad_25_h,
  /* <dr2> */ output ad_26_h,
  /* <dr1> */ output ad_27_h,
  /* <cf2> */ output ad_28_a_h,
  /* <cp1> */ output ad_28_h,
  /* <ce1> */ output ad_29_a_h,
  /* <el1> */ output ad_29_h,
  /* <ep1> */ input  ad_30_h,
  /* <am1> */ output ad_cg_24_h,
  /* <am2> */ output ad_cg_26_h,
  /* <aj1> */ output ad_cp_24_h,
  /* <af1> */ output ad_cp_26_h,
  /* <cu2> */ output ad_cry_25_h,
  /* <ct2> */ output ad_cry_25_l,
  /* <al1> */ input  ad_cry_30_h,
  /* <cv2> */ output ad_ex_22_h,
  /* <cr1> */ output ad_ex_23_h,
  /* <cl2> */ output ad_overflow_24_l,
  /* <es2> */ input  adx_23_h,
  /* <cf1> */ output adx_24_a_h,
  /* <cj2> */ output adx_24_h,
  /* <dk1> */ output adx_28_h,
  /* <es1> */ output adx_29_h,
  /* <cj1> */ input  adx_30_h,
  /* <al2> */ output adx_cg_24_h,
  /* <ak2> */ output adx_cg_27_h,
  /* <ae1> */ output adx_cp_24_h,
  /* <af2> */ output adx_cp_27_h,
  /* <ak1> */ input  adx_cry_30_h,
  /* <fr2> */ input  apr_fm_adr_10_h,
  /* <fp2> */ input  apr_fm_adr_1_h,
  /* <fs1> */ input  apr_fm_adr_2_h,
  /* <fn1> */ input  apr_fm_adr_4_h,
  /* <fr1> */ input  apr_fm_block_1_h,
  /* <fm1> */ input  apr_fm_block_2_h,
  /* <fp1> */ input  apr_fm_block_4_h,
  /* <fj2> */ output ar_24_a_h,
  /* <ft2> */ output ar_24_b_h,
  /* <fs2> */ output ar_24_c_h,
  /* <dm2> */ output ar_24_d_h,
  /* <bk2> */ output ar_24_h,
  /* <fc1> */ output ar_25_a_h,
  /* <fu2> */ output ar_25_b_h,
  /* <fv2> */ output ar_25_c_h,
  /* <bl2> */ output ar_25_h,
  /* <ff2> */ output ar_26_a_h,
  /* <cl1> */ output ar_26_b_h,
  /* <ch2> */ output ar_26_c_h,
  /* <eu2> */ output ar_27_a_h,
  /* <ck2> */ output ar_27_b_h,
  /* <cm1> */ output ar_27_c_h,
  /* <ev2> */ output ar_28_a_h,
  /* <fk1> */ output ar_28_b_h,
  /* <fk2> */ output ar_28_c_h,
  /* <et2> */ output ar_29_a_h,
  /* <fl2> */ output ar_29_b_h,
  /* <fl1> */ output ar_29_c_h,
  /* <bk1> */ input  ar_30_h,
  /* <bl1> */ input  ar_31_h,
  /* <em2> */ input  armm_24_h,
  /* <ea1> */ input  armm_25_h,
  /* <ee1> */ input  armm_26_h,
  /* <dd2> */ input  armm_27_h,
  /* <de1> */ input  armm_28_h,
  /* <ef2> */ input  armm_29_h,
  /* <as2> */ output arx_24_a_h,
  /* <br2> */ output arx_24_b_h,
  /* <ej2> */ output arx_24_h,
  /* <as1> */ output arx_25_a_h,
  /* <cm2> */ output arx_25_b_h,
  /* <bd2> */ output arx_25_h,
  /* <dc1> */ output arx_26_h,
  /* <aj2> */ output arx_27_h,
  /* <ac1> */ output arx_28_h,
  /* <aa1> */ output arx_29_h,
  /* <ej1> */ input  arx_30_h,
  /* <bd1> */ input  arx_31_h,
  /* <bm2> */ output br_24_a_h,
  /* <bm1> */ input  br_30_a_h,
  /* <be2> */ output brx_24_h,
  /* <be1> */ input  brx_30_h,
  /* <em1> */ input  cache_data_24_b_h,
  /* <ed2> */ input  cache_data_25_b_h,
  /* <ee2> */ input  cache_data_26_b_h,
  /* <dd1> */ input  cache_data_27_b_h,
  /* <dl2> */ input  cache_data_28_b_h,
  /* <cc1> */ input  cache_data_29_b_h,
  /* <cr2> */ input  clk_edp_24_h,
  /* <ce2> */ input  con_fm_write_18to35_l,
  /* <ar1> */ input  cram_Nr_24_h,
  /* <ap1> */ input  cram_Nr_25_h,
  /* <ba1> */ input  cram_Nr_26_h,
  /* <ap2> */ input  cram_Nr_27_h,
  /* <av2> */ input  cram_Nr_28_h,
  /* <au2> */ input  cram_Nr_29_h,
  /* <an1> */ input  cram_ad_boole_24_h,
  /* <ad2> */ input  cram_ad_sel_1_24_h,
  /* <ah2> */ input  cram_ad_sel_2_24_h,
  /* <ae2> */ input  cram_ad_sel_4_24_h,
  /* <ad1> */ input  cram_ad_sel_8_24_h,
  /* <bn1> */ input  cram_ada_dis_24_h,
  /* <bj1> */ input  cram_ada_sel_1_24_h,
  /* <bf2> */ input  cram_ada_sel_2_24_h,
  /* <bt2> */ input  cram_adb_sel_1_24_h,
  /* <bt1> */ input  cram_adb_sel_1_24_h,
  /* <bs1> */ input  cram_adb_sel_2_24_h,
  /* <er1> */ input  cram_arm_sel_4_a_h,
  /* <ff1> */ input  cram_arxm_sel_4_06_h,
  /* <dj2> */ input  cram_br_load_a_h,
  /* <ar2> */ input  cram_brx_load_a_h,
  /* <fe2> */ input  ctl_ad_to_ebus_r_h,
  /* <eh2> */ input  ctl_arr_clr_h,
  /* <ek2> */ input  ctl_arr_load_a_l,
  /* <dh2> */ input  ctl_arr_load_b_l,
  /* <en1> */ input  ctl_arr_sel_1_h,
  /* <ek1> */ input  ctl_arr_sel_2_h,
  /* <br1> */ input  ctl_arx_load_h,
  /* <fj1> */ input  ctl_arxr_sel_1_h,
  /* <fd2> */ input  ctl_arxr_sel_2_h,
  /* <bu2> */ input  ctl_mq_sel_1_h,
  /* <bv2> */ input  ctl_mq_sel_2_h,
  /* <dn1> */ input  ctl_mqm_en_h,
  /* <dj1> */ input  ctl_mqm_sel_1_h,
  /* <dm1> */ input  ctl_mqm_sel_2_h,
  /* <fd1> */ input  diag_04_a_h,
  /* <fa1> */ input  diag_05_a_h,
  /* <fe1> */ input  diag_06_a_h,
  /* <ef1> */ input  diag_read_func_12x_h,
  /* <dv2> */ output ebus_d24_e_h,
  /* <ds2> */ output ebus_d25_e_h,
  /* <dt2> */ output ebus_d26_e_h,
  /* <dp1> */ output ebus_d27_e_h,
  /* <dp2> */ output ebus_d28_e_h,
  /* <du2> */ output ebus_d29_e_h,
  /* <fm2> */ output edp_fm_parity_24to29_h,
  /* <cs2> */ input  mq_22_h,
  /* <cd2> */ output mq_24_h,
  /* <cs1> */ output mq_28_h,
  /* <df1> */ output mq_29_h,
  /* <cd1> */ input  mq_30_h,
  /* <ed1> */ input  sh_24_h,
  /* <ec1> */ input  sh_25_h,
  /* <ds1> */ input  sh_26_h,
  /* <da1> */ input  sh_27_h,
  /* <de2> */ input  sh_28_h,
  /* <ca1> */ input  sh_29_h,
  /* <bj2> */ input  vma_held_or_pc_24_h,
  /* <bh2> */ input  vma_held_or_pc_25_h,
  /* <bf1> */ input  vma_held_or_pc_26_h,
  /* <bp2> */ input  vma_held_or_pc_27_h,
  /* <bp1> */ input  vma_held_or_pc_28_h,
  /* <bc1> */ input  vma_held_or_pc_29_h
);

`include "edp41nets.svh"

endmodule	// edp41
