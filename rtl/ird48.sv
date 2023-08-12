module ird48(
  /* <cp2> */ output adEq0_l,
  /* <ep2> */  input ad_00_a_h,
  /* <en1> */  input ad_01_h,
  /* <el1> */  input ad_02_h,
  /* <ft2> */  input ad_03_h,
  /* <fs1> */  input ad_04_h,
  /* <fp2> */  input ad_05_h,
  /* <fa1> */  input ad_06_a_h,
  /* <fm2> */  input ad_06to11Eq0_l,
  /* <eu2> */  input ad_07_h,
  /* <er1> */  input ad_08_h,
  /* <fj2> */  input ad_09_h,
  /* <ff2> */  input ad_10_h,
  /* <fc1> */  input ad_11_h,
  /* <fd2> */  input ad_12_a_h,
  /* <fn1> */  input ad_12to17Eq0_l,
  /* <fm1> */  input ad_18to23Eq0_l,
  /* <fl2> */  input ad_24to29Eq0_l,
  /* <fl1> */  input ad_30to35Eq0_l,
  /* <av2> */  input ad_cg_00_h,
  /* <au2> */  input ad_cg_02_h,
  /* <ap2> */  input ad_cg_06_h,
  /* <as2> */  input ad_cg_08_h,
  /* <ak1> */  input ad_cg_12_h,
  /* <ae2> */  input ad_cg_14_h,
  /* <ap1> */  input ad_cg_18_h,
  /* <ar1> */  input ad_cg_20_h,
  /* <aj1> */  input ad_cg_24_h,
  /* <ad1> */  input ad_cg_26_h,
  /* <aj2> */  input ad_cg_30_h,
  /* <ak2> */  input ad_cg_32_h,
  /* <as1> */  input ad_cp_00_h,
  /* <at2> */  input ad_cp_02_h,
  /* <ar2> */  input ad_cp_06_h,
  /* <al2> */  input ad_cp_08_h,
  /* <aa1> */  input ad_cp_12_h,
  /* <ac1> */  input ad_cp_14_h,
  /* <am1> */  input ad_cp_18_h,
  /* <am2> */  input ad_cp_20_h,
  /* <af1> */  input ad_cp_24_h,
  /* <af2> */  input ad_cp_26_h,
  /* <ad2> */  input ad_cp_30_h,
  /* <ae1> */  input ad_cp_32_h,
  /* <ba1> */ output ad_cry_06_h,
  /* <cp1> */ output ad_cry_12_h,
  /* <cl2> */ output ad_cry_18_h,
  /* <ct2> */ output ad_cry_24_h,
  /* <ah2> */ output ad_cry_30_h,
  /* <ch2> */ output ad_cry_36_b_h,
  /* <dm2> */ output ad_cry_Ng02_a_h,
  /* <cc1> */ output ad_cry_Ng02_a_l,
  /* <ca1> */ output ad_cry_Ng02_h,
  /* <bp1> */  input adx_cg_00_h,
  /* <bm1> */  input adx_cg_03_h,
  /* <bn1> */  input adx_cg_06_h,
  /* <bm2> */  input adx_cg_09_h,
  /* <bu2> */  input adx_cg_12_h,
  /* <bs2> */  input adx_cg_15_h,
  /* <bt2> */  input adx_cg_18_h,
  /* <bv2> */  input adx_cg_21_h,
  /* <bh2> */  input adx_cg_24_h,
  /* <bf2> */  input adx_cg_27_h,
  /* <bf1> */  input adx_cg_30_h,
  /* <bj1> */  input adx_cg_33_h,
  /* <bk2> */  input adx_cp_00_h,
  /* <bl1> */  input adx_cp_03_h,
  /* <bl2> */  input adx_cp_06_h,
  /* <bk1> */  input adx_cp_09_h,
  /* <br1> */  input adx_cp_12_h,
  /* <br2> */  input adx_cp_15_h,
  /* <bs1> */  input adx_cp_18_h,
  /* <bp2> */  input adx_cp_21_h,
  /* <bc1> */  input adx_cp_24_h,
  /* <bd1> */  input adx_cp_27_h,
  /* <be1> */  input adx_cp_30_h,
  /* <bd2> */  input adx_cp_33_h,
  /* <cd2> */ output adx_cry_06_h,
  /* <dt2> */ output adx_cry_12_h,
  /* <cf2> */ output adx_cry_18_h,
  /* <dn1> */ output adx_cry_24_h,
  /* <bj2> */ output adx_cry_30_h,
  /* <er2> */  input bp_only_er2_h,
  /* <es2> */  input bp_only_es2_h,
  /* <em2> */  input cache_data_00_c_h,
  /* <em1> */  input cache_data_01_c_h,
  /* <el2> */  input cache_data_02_c_h,
  /* <fs2> */  input cache_data_03_c_h,
  /* <fr2> */  input cache_data_04_c_h,
  /* <fr1> */  input cache_data_05_c_h,
  /* <ev2> */  input cache_data_06_c_h,
  /* <et2> */  input cache_data_07_c_h,
  /* <es1> */  input cache_data_08_c_h,
  /* <fh2> */  input cache_data_09_c_h,
  /* <ff1> */  input cache_data_10_c_h,
  /* <fd1> */  input cache_data_11_c_h,
  /* <fe1> */  input cache_data_12_c_h,
  /* <cr2> */  input clk_ir_h,
  /* <fe2> */  input clk_mb_xfer_l,
  /* <df2> */  input con_load_dram_l,
  /* <da1> */  input con_load_ir_l,
  /* <ed2> */  input cram_Nr_07_f_h,
  /* <ds1> */  input cram_Nr_08_f_h,
  /* <cj2> */  input ctl_ad_long_h,
  /* <be2> */  input ctl_adx_cry_36_a_h,
  /* <an1> */  input ctl_inh_cry_18_l,
  /* <al1> */  input ctl_specSlgen_cry_18_h,
  /* <eh2> */  input diag_04_a_h,
  /* <ej1> */  input diag_05_a_h,
  /* <ee1> */  input diag_06_a_h,
  /* <ef2> */  input diag_load_func_06x_l,
  /* <ef1> */  input diag_read_func_13x_l,
  /* <cd1> */ output dram_a_00_h,
  /* <ce2> */ output dram_a_01_h,
  /* <ce1> */ output dram_a_02_h,
  /* <ec1> */ output dram_b_00_h,
  /* <cf1> */ output dram_b_01_h,
  /* <ds2> */ output dram_b_02_h,
  /* <dc1> */ output dram_j_01_h,
  /* <cl1> */ output dram_j_02_h,
  /* <dv2> */ output dram_j_03_h,
  /* <dk2> */ output dram_j_04_h,
  /* <dd2> */ output dram_j_07_h,
  /* <cm2> */ output dram_j_08_h,
  /* <du2> */ output dram_j_09_h,
  /* <dl2> */ output dram_j_10_h,
  /* <ck2> */ output dram_odd_parity_h,
  /* <dd1> */ output ebus_d12_e_h,
  /* <de2> */ output ebus_d13_e_h,
  /* <cu2> */ output ebus_d14_e_h,
  /* <cv2> */ output ebus_d15_e_h,
  /* <dj1> */ output ebus_d16_e_h,
  /* <cs2> */ output ebus_d17_e_h,
  /* <ek2> */ output ir_03_h,
  /* <fk2> */ output ir_04_h,
  /* <ej2> */ output ir_05_h,
  /* <ep1> */ output ir_06_h,
  /* <fv2> */ output ir_07_h,
  /* <fu2> */ output ir_08_h,
  /* <fp1> */ output ir_09_h,
  /* <ck1> */ output ir_IO_legal_h,
  /* <fk1> */ output ir_acEq0_h,
  /* <fj1> */ output ir_acEq0_l,
  /* <df1> */ output ir_ac_09_h,
  /* <cn1> */ output ir_ac_10_h,
  /* <ea1> */ output ir_ac_11_h,
  /* <dr1> */ output ir_ac_12_h,
  /* <cj1> */ output ir_jrst_0Cm_l,
  /* <de1> */ output ir_norm_08_h,
  /* <cm1> */ output ir_norm_09_h,
  /* <cs1> */ output ir_norm_10_h,
  /* <cr1> */ output ir_test_satisfied_h,
  /* <ee2> */ output ir_test_satisfied_l
);

`include "ird48.svh"

endmodule	// ird48
