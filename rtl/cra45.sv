module cra45(
  /* <da1> */ input  adEq0_l,
  /* <ce2> */ input  ad_00_h,
  /* <cf1> */ input  ad_cry_Ng02_h,
  /* <dc1> */ input  adx_00_a_h,
  /* <be2> */ input  ar_00_h,
  /* <bu2> */ input  ar_12_d_h,
  /* <cs2> */ input  ar_18_d_h,
  /* <cv2> */ input  arx_00_b_h,
  /* <dm1> */ input  arx_01_b_h,
  /* <cs1> */ input  arx_13_b_h,
  /* <bv2> */ input  br_00_a_h,
  /* <bf2> */ input  clk4_force_1777_h,
  /* <ad1> */ input  clk4_pf_disp_07_h,
  /* <ah2> */ input  clk4_pf_disp_08_h,
  /* <ap1> */ input  clk4_pf_disp_09_h,
  /* <bp2> */ input  clk4_pf_disp_10_h,
  /* <cr2> */ input  clk_cra_h,
  /* <br2> */ input  con2_long_en_l,
  /* <de2> */ input  con_cond_adr_10_h,
  /* <ac1> */ input  con_nicond_07_h,
  /* <af2> */ input  con_nicond_08_h,
  /* <am2> */ input  con_nicond_09_h,
  /* <cr1> */ input  con_skip_en_40to47_l,
  /* <dd1> */ input  con_skip_en_50to57_l,
  /* <ad2> */ input  con_sr_00_h,
  /* <ak1> */ input  con_sr_01_h,
  /* <an1> */ input  con_sr_02_h,
  /* <bs1> */ input  con_sr_03_h,
  /* <ck1> */ input  cr02_dia_func_051_08_l,
  /* <ee1> */ input  cr02_dia_func_052_08_l,
  /* <at2> */ input  cr02_dia_func_053_08_l,
  /* <dl1> */ output cra1_adr_00_a_h,
  /* <dp2> */ output cra1_adr_00_b_h,
  /* <dk1> */ output cra1_adr_00_c_h,
  /* <dj1> */ output cra1_adr_00_d_h,
  /* <df2> */ output cra1_adr_00_e_h,
  /* <fd1> */ output cra1_adr_01_a_l,
  /* <fd2> */ output cra1_adr_01_b_h,
  /* <fa1> */ output cra1_adr_01_c_l,
  /* <fc1> */ output cra1_adr_01_d_h,
  /* <et2> */ output cra1_adr_01_e_l,
  /* <el1> */ output cra1_adr_02_a_l,
  /* <ek1> */ output cra1_adr_02_b_h,
  /* <el2> */ output cra1_adr_02_c_l,
  /* <ek2> */ output cra1_adr_02_d_h,
  /* <ef2> */ output cra1_adr_02_e_l,
  /* <fp1> */ output cra1_adr_03_a_l,
  /* <fs1> */ output cra1_adr_03_b_h,
  /* <ft2> */ output cra1_adr_03_c_l,
  /* <fr1> */ output cra1_adr_03_d_h,
  /* <fn1> */ output cra1_adr_03_e_l,
  /* <fl1> */ output cra1_adr_04_a_l,
  /* <fl2> */ output cra1_adr_04_b_h,
  /* <fh2> */ output cra1_adr_04_c_l,
  /* <fk2> */ output cra1_adr_04_d_h,
  /* <ff2> */ output cra1_adr_04_e_l,
  /* <fr2> */ output cra1_adr_05_a_l,
  /* <fu2> */ output cra1_adr_05_b_h,
  /* <fp2> */ output cra1_adr_05_c_l,
  /* <fs2> */ output cra1_adr_05_d_h,
  /* <fm2> */ output cra1_adr_05_e_l,
  /* <em1> */ output cra1_adr_06_a_l,
  /* <ep1> */ output cra1_adr_06_b_h,
  /* <en1> */ output cra1_adr_06_c_l,
  /* <er1> */ output cra1_adr_06_d_h,
  /* <ep2> */ output cra1_adr_06_e_l,
  /* <cd1> */ output cra2_adr_07_a_h,
  /* <ce1> */ output cra2_adr_07_b_h,
  /* <cc1> */ output cra2_adr_07_c_h,
  /* <cd2> */ output cra2_adr_07_d_h,
  /* <ca1> */ output cra2_adr_07_e_h,
  /* <au2> */ output cra2_adr_08_a_h,
  /* <as2> */ output cra2_adr_08_b_h,
  /* <ar2> */ output cra2_adr_08_c_h,
  /* <ar1> */ output cra2_adr_08_d_h,
  /* <as1> */ output cra2_adr_08_e_h,
  /* <am1> */ output cra2_adr_09_a_h,
  /* <al2> */ output cra2_adr_09_b_h,
  /* <al1> */ output cra2_adr_09_c_h,
  /* <ak2> */ output cra2_adr_09_d_h,
  /* <aj2> */ output cra2_adr_09_e_h,
  /* <ej1> */ output cra2_adr_10_a_h,
  /* <ej2> */ output cra2_adr_10_b_h,
  /* <eh2> */ output cra2_adr_10_c_h,
  /* <ee2> */ output cra2_adr_10_d_h,
  /* <ed2> */ output cra2_adr_10_e_h,
  /* <ct2> */ input  cra2_spare_h,
  /* <dm2> */ output cra3_disp_00_h,
  /* <dt2> */ output cra3_disp_01_h,
  /* <ef1> */ output cra3_disp_02_h,
  /* <em2> */ output cra3_disp_03_h,
  /* <es2> */ output cra3_disp_04_h,
  /* <dl2> */ output cra3_disp_parity_h,
  /* <cp2> */ input  cram_cond_03s_h,
  /* <cp1> */ input  cram_cond_04s_h,
  /* <cn1> */ input  cram_cond_05s_h,
  /* <dr2> */ input  cram_j00_h,
  /* <fj1> */ input  cram_j01_h,
  /* <fk1> */ input  cram_j02_h,
  /* <fe2> */ input  cram_j03_h,
  /* <fe1> */ input  cram_j04_h,
  /* <be1> */ input  cram_j05_h,
  /* <bd2> */ input  cram_j06_h,
  /* <av2> */ input  cram_j07_h,
  /* <ba1> */ input  cram_j08_h,
  /* <ae2> */ input  cram_j09_h,
  /* <af1> */ input  cram_j10_h,
  /* <dv2> */ input  diag_04_a_l,
  /* <du2> */ input  diag_05_a_l,
  /* <ds1> */ input  diag_05_a_l,
  /* <bn1> */ input  diag_read_func_14x_l,
  /* <bm1> */ input  dram_a_00_h,
  /* <bj2> */ input  dram_a_01_h,
  /* <bk2> */ input  dram_a_02_h,
  /* <bh2> */ input  dram_b_00_h,
  /* <bl2> */ input  dram_b_01_h,
  /* <cl1> */ input  dram_b_02_h,
  /* <dp1> */ input  dram_j_01_h,
  /* <dr1> */ input  dram_j_02_h,
  /* <es1> */ input  dram_j_03_h,
  /* <er2> */ input  dram_j_04_h,
  /* <ae1> */ input  dram_j_07_h,
  /* <bm2> */ input  dram_j_08_h,
  /* <bj1> */ input  dram_j_09_h,
  /* <bk1> */ input  dram_j_10_h,
  /* <ff1> */ input  ea_type_07_h,
  /* <ds2> */ input  ea_type_08_h,
  /* <bs2> */ input  ea_type_09_h,
  /* <cj2> */ input  ea_type_10_h,
  /* <dk2> */ output ebus_d00_e_h,
  /* <dj2> */ output ebus_d01_e_h,
  /* <df1> */ output ebus_d02_e_h,
  /* <ed1> */ output ebus_d03_e_h,
  /* <ec1> */ output ebus_d04_e_h,
  /* <ea1> */ output ebus_d05_e_h,
  /* <cm2> */ input  ir_acEq0_h,
  /* <bd1> */ input  ir_norm_08_h,
  /* <bt2> */ input  ir_norm_09_h,
  /* <ck2> */ input  ir_norm_10_h,
  /* <dd2> */ input  mcl6_pc_section_0_h,
  /* <bl1> */ input  mq_34_h,
  /* <cl2> */ input  mq_35_h,
  /* <dh2> */ input  mr_reset_04_h,
  /* <de1> */ input  scd1_scadEq0_l,
  /* <cf2> */ input  scd1_scad_sign_h,
  /* <bf1> */ input  scd2_fe_sign_h,
  /* <cm1> */ input  scd2_sc_sign_h,
  /* <bc1> */ input  scd4_fpd_h,
  /* <br1> */ input  scd4_nicond_10_h,
  /* <cu2> */ input  shm1_ar_par_odd_b_l,
  /* <cj1> */ input  shm1_indexed_h,
  /* <aa1> */ input  shm4_sh_00_a_h,
  /* <aj1> */ input  shm4_sh_01_a_h,
  /* <ap2> */ input  shm4_sh_02_a_h,
  /* <bp1> */ input  shm4_sh_03_a_h,
  /* <ch2> */ input  vma1_local_ac_address_l
);

`include "cra45nets.svh"

endmodule	// cra45
