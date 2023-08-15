module vma38(
  /* <cj1> */ input  ad_13_h,
  /* <ch2> */ input  ad_14_h,
  /* <cj2> */ input  ad_15_h,
  /* <cm1> */ input  ad_16_a_h,
  /* <au2> */ input  ad_17_a_h,
  /* <at2> */ input  ad_18_a_h,
  /* <ar1> */ input  ad_19_h,
  /* <bd2> */ input  ad_20_h,
  /* <bd1> */ input  ad_21_h,
  /* <av2> */ input  ad_22_a_h,
  /* <ba1> */ input  ad_23_a_h,
  /* <br2> */ input  ad_24_a_h,
  /* <bm2> */ input  ad_25_h,
  /* <bs1> */ input  ad_26_h,
  /* <bp2> */ input  ad_27_h,
  /* <et2> */ input  ad_28_a_h,
  /* <es2> */ input  ad_29_a_h,
  /* <ep2> */ input  ad_30_a_h,
  /* <er2> */ input  ad_31_h,
  /* <dk1> */ input  ad_32_h,
  /* <dl1> */ input  ad_33_h,
  /* <dk2> */ input  ad_34_a_h,
  /* <dm1> */ input  ad_35_a_h,
  /* <cr2> */ input  clk3_vma_h,
  /* <ac1> */ input  con_condSlsel_vma_h,
  /* <fr2> */ input  con_condSlvmaGETSNr_h,
  /* <dd1> */ input  con_datao_apr_l,
  /* <ck1> */ input  con_load_prev_context_l,
  /* <bj2> */ input  con_vma_sel_1_l,
  /* <bl2> */ input  con_vma_sel_2_l,
  /* <fp2> */ input  cram_Nr_00_a_h,
  /* <fs1> */ input  cram_Nr_01_a_h,
  /* <fu2> */ input  cram_Nr_02_a_h,
  /* <fs2> */ input  cram_Nr_03_a_h,
  /* <fr1> */ input  cram_Nr_04_a_h,
  /* <es1> */ input  csh3_gate_vma_27to33_h,
  /* <de1> */ input  ctl1_load_pc_l,
  /* <cp1> */ input  diag_04_b_h,
  /* <cr1> */ input  diag_05_b_h,
  /* <cl2> */ input  diag_06_b_h,
  /* <cn1> */ input  diag_read_func_15x_l,
  /* <ed1> */ output ebus_d11_e_h,
  /* <bl1> */ output ebus_d13_e_h,
  /* <bt2> */ output ebus_d15_e_h,
  /* <af2> */ output ebus_d17_e_h,
  /* <be2> */ output ebus_d19_e_h,
  /* <cs1> */ output ebus_d21_e_h,
  /* <bf2> */ output ebus_d23_e_h,
  /* <dc1> */ input  mcl1_load_vma_held_l,
  /* <am2> */ input  mcl2_vma_extended_l,
  /* <al2> */ input  mcl2_vma_read_or_write_l,
  /* <bc1> */ input  mcl4_vmaGETSad_h,
  /* <fm2> */ input  mcl4_vma_inc_h,
  /* <ap1> */ input  mcl4_vmax_sel_1_h,
  /* <am1> */ input  mcl4_vmax_sel_2_h,
  /* <ff2> */ input  mcl5_adr_err_h,
  /* <ff1> */ input  mcl5_vmax_en_l,
  /* <as2> */ input  mcl6_page_uebr_ref_a_h,
  /* <ap2> */ input  mcl6_vma_fetch_h,
  /* <fv2> */ input  scd3_trap_mix_32_h,
  /* <ft2> */ input  scd3_trap_mix_33_h,
  /* <fp1> */ input  scd3_trap_mix_34_h,
  /* <fn1> */ input  scd3_trap_mix_35_h,
  /* <dd2> */ output vma1_ac_ref_a_h,
  /* <da1> */ output vma1_ac_ref_a_l,
  /* <bm1> */ output vma1_ac_ref_h,
  /* <as1> */ output vma1_local_ac_address_l,
  /* <fm1> */ output vma1_vma_32_b_h,
  /* <fl1> */ output vma1_vma_33_b_h,
  /* <fe1> */ output vma1_vma_34_b_h,
  /* <fd2> */ output vma1_vma_35_b_h,
  /* <bv2> */ output vma1_vma_section_0_l,
  /* <fe2> */ output vma2_vma_12_h,
  /* <cf1> */ output vma2_vma_13_a_h,
  /* <cd2> */ output vma2_vma_14_a_h,
  /* <ca1> */ output vma2_vma_15_a_h,
  /* <bu2> */ output vma2_vma_16_a_h,
  /* <aa1> */ output vma2_vma_17_a_h,
  /* <aj1> */ output vma2_vma_17_h,
  /* <cc1> */ output vma2_vma_18_h,
  /* <ce1> */ output vma2_vma_19_h,
  /* <bs2> */ output vma2_vma_20_h,
  /* <bj1> */ output vma2_vma_21_a_h,
  /* <bp1> */ output vma2_vma_21_h,
  /* <cl1> */ output vma2_vma_22_a_h,
  /* <br1> */ output vma2_vma_22_h,
  /* <cp2> */ output vma2_vma_23_a_h,
  /* <bn1> */ output vma2_vma_23_h,
  /* <df2> */ output vma2_vma_24_a_h,
  /* <cf2> */ output vma2_vma_24_h,
  /* <dh2> */ output vma2_vma_25_a_h,
  /* <ce2> */ output vma2_vma_25_h,
  /* <dv2> */ output vma2_vma_26_a_h,
  /* <cd1> */ output vma2_vma_26_h,
  /* <dl2> */ output vma2_vma_27_h,
  /* <dm2> */ output vma2_vma_28_h,
  /* <dn1> */ output vma2_vma_29_h,
  /* <dp1> */ output vma2_vma_30_h,
  /* <dr2> */ output vma2_vma_31_h,
  /* <ea1> */ output vma2_vma_32_h,
  /* <dt2> */ output vma2_vma_33_h,
  /* <ds2> */ output vma2_vma_34_h,
  /* <du2> */ output vma2_vma_35_h,
  /* <bk2> */ output vma3_match_13to35_l,
  /* <el2> */ output vma3_pc_section_0_l,
  /* <ej2> */ output vma4_pcs_section_0_l,
  /* <bk1> */ output vma4_vma_13_in_h,
  /* <bh2> */ output vma4_vma_14_in_h,
  /* <bf1> */ output vma4_vma_15_in_h,
  /* <be1> */ output vma4_vma_16_in_h,
  /* <fd1> */ output vma4_vma_17_in_h,
  /* <ae2> */ output vma_18_a_h,
  /* <af1> */ output vma_19_a_h,
  /* <ck2> */ output vma_20_a_h,
  /* <fc1> */ output vma_27_g_h,
  /* <er1> */ output vma_28_g_h,
  /* <ep1> */ output vma_29_g_h,
  /* <em1> */ output vma_30_g_h,
  /* <fa1> */ output vma_31_g_h,
  /* <eu2> */ output vma_32_g_h,
  /* <ev2> */ output vma_33_g_h,
  /* <ar2> */ output vma_ac_ref_l,
  /* <ak1> */ output vma_held_or_pc_13_h,
  /* <ak2> */ output vma_held_or_pc_14_h,
  /* <aj2> */ output vma_held_or_pc_15_h,
  /* <ah2> */ output vma_held_or_pc_16_h,
  /* <ae1> */ output vma_held_or_pc_17_h,
  /* <ad1> */ output vma_held_or_pc_18_h,
  /* <ad2> */ output vma_held_or_pc_19_h,
  /* <ct2> */ output vma_held_or_pc_20_h,
  /* <cu2> */ output vma_held_or_pc_21_h,
  /* <cm2> */ output vma_held_or_pc_22_h,
  /* <cs2> */ output vma_held_or_pc_23_h,
  /* <dj1> */ output vma_held_or_pc_24_h,
  /* <dj2> */ output vma_held_or_pc_25_h,
  /* <df1> */ output vma_held_or_pc_26_h,
  /* <de2> */ output vma_held_or_pc_27_h,
  /* <ee2> */ output vma_held_or_pc_28_h,
  /* <ee1> */ output vma_held_or_pc_29_h,
  /* <ed2> */ output vma_held_or_pc_30_h,
  /* <ec1> */ output vma_held_or_pc_31_h,
  /* <fk2> */ output vma_held_or_pc_32_h,
  /* <fl2> */ output vma_held_or_pc_33_h,
  /* <fk1> */ output vma_held_or_pc_34_h,
  /* <fj1> */ output vma_held_or_pc_35_h
);

`include "vma38nets.svh"

endmodule	// vma38
