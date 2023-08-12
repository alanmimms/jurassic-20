module ccw12(
  /* <au2> */  input ccl_act_flag_clr_l,
  /* <ds1> */  input ccl_act_flag_req_l,
  /* <ck2> */  input ccl_af_wd0_req_h,
  /* <ce2> */  input ccl_af_wd1_req_h,
  /* <bs1> */  input ccl_af_wd2_req_h,
  /* <bk1> */  input ccl_af_wd3_req_h,
  /* <dk2> */  input ccl_alu_minus_l,
  /* <dd1> */  input ccl_alu_plus_l,
  /* <cm2> */  input ccl_ccw_reg_load_h,
  /* <br2> */  input ccl_ccwf_clr_l,
  /* <cl2> */  input ccl_ccwf_req_h,
  /* <bd1> */  input ccl_chan_ept_l,
  /* <al2> */  input ccl_chan_to_mem_h,
  /* <fd2> */  input ccl_cons_0_h,
  /* <ep1> */  input ccl_cons_1_h,
  /* <ep2> */  input ccl_cons_2_h,
  /* <ar1> */  input ccl_csh_chan_cyc_h,
  /* <du2> */  input ccl_err_req_l,
  /* <av2> */  input ccl_mb_cyc_t2_l,
  /* <ed1> */  input ccl_mb_rip_h,
  /* <cv2> */  input ccl_mem_err_latch_l,
  /* <as1> */  input ccl_mem_store_req_h,
  /* <dv2> */  input ccl_mem_store_req_l,
  /* <ce1> */  input ccl_wcEq0_l,
  /* <ef1> */  input ccl_wcEq1_h,
  /* <dr1> */  input ccl_wcEq2_h,
  /* <ff1> */  input ccl_wcEq3_h,
  /* <ch2> */  input ccl_wc_ge4_l,
  /* <at2> */  input ccl_wd_taken_h,
  /* <dr2> */  input ccl_zero_fill_h,
  /* <ek2> */  input ccl_zero_fill_l,
  /* <cd1> */ output ccw_act_ctr_0_en_l,
  /* <er1> */ output ccw_act_ctr_1_en_l,
  /* <ek1> */ output ccw_act_ctr_2_en_l,
  /* <ct2> */ output ccw_act_flag_req_ena_h,
  /* <fj1> */  input ccw_buf_02_in_h,
  /* <fs1> */ output ccw_buf_14_in_h,
  /* <fr1> */ output ccw_buf_15_in_h,
  /* <fp1> */ output ccw_buf_16_in_h,
  /* <fs2> */ output ccw_buf_17_in_h,
  /* <fm1> */ output ccw_buf_18_in_h,
  /* <fn1> */ output ccw_buf_19_in_h,
  /* <ft2> */ output ccw_buf_20_in_h,
  /* <fu2> */ output ccw_buf_21_in_h,
  /* <fv2> */ output ccw_buf_22_in_h,
  /* <en1> */ output ccw_buf_23_in_h,
  /* <fc1> */ output ccw_buf_24_in_h,
  /* <fa1> */ output ccw_buf_25_in_h,
  /* <er2> */ output ccw_buf_26_in_h,
  /* <es2> */ output ccw_buf_27_in_h,
  /* <et2> */ output ccw_buf_28_in_h,
  /* <ev2> */ output ccw_buf_29_in_h,
  /* <eu2> */ output ccw_buf_30_in_h,
  /* <fd1> */ output ccw_buf_31_in_h,
  /* <fr2> */ output ccw_buf_32_in_h,
  /* <fp2> */ output ccw_buf_33_in_h,
  /* <fk1> */ output ccw_buf_34_in_h,
  /* <fl1> */ output ccw_buf_35_in_h,
  /* <ca1> */ output ccw_buf_adr_0_h,
  /* <cn1> */ output ccw_buf_adr_0_l,
  /* <bc1> */ output ccw_buf_adr_1_h,
  /* <dp2> */ output ccw_buf_adr_1_l,
  /* <bk2> */ output ccw_buf_adr_2_h,
  /* <df1> */ output ccw_buf_adr_2_l,
  /* <cj1> */ output ccw_ccwf_req_ena_h,
  /* <de2> */ output ccw_ccwf_waiting_h,
  /* <em1> */ output ccw_cha_14_h,
  /* <da1> */ output ccw_cha_15_h,
  /* <ff2> */ output ccw_cha_16_h,
  /* <es1> */ output ccw_cha_17_h,
  /* <ds2> */ output ccw_cha_18_h,
  /* <cp2> */ output ccw_cha_19_h,
  /* <ej2> */ output ccw_cha_20_h,
  /* <dc1> */ output ccw_cha_21_h,
  /* <dp1> */ output ccw_cha_22_h,
  /* <dh2> */ output ccw_cha_23_h,
  /* <el1> */ output ccw_cha_24_h,
  /* <el2> */ output ccw_cha_25_h,
  /* <em2> */ output ccw_cha_26_h,
  /* <cs1> */ output ccw_cha_27_h,
  /* <dn1> */ output ccw_cha_28_h,
  /* <dj2> */ output ccw_cha_29_h,
  /* <dl2> */ output ccw_cha_30_h,
  /* <cj2> */ output ccw_cha_31_h,
  /* <ec1> */ output ccw_cha_32_h,
  /* <cp1> */ output ccw_cha_33_h,
  /* <dm1> */ output ccw_cha_34_h,
  /* <de1> */ output ccw_cha_35_h,
  /* <aa1> */ output ccw_diag_load_func_070_h,
  /* <fe1> */ output ccw_mem_adrEq0_l,
  /* <ee1> */ output ccw_mem_store_ena_h,
  /* <cd2> */  input ccw_mix_14_h,
  /* <bv2> */  input ccw_mix_15_h,
  /* <bs2> */  input ccw_mix_16_h,
  /* <br1> */  input ccw_mix_17_h,
  /* <fm2> */  input ccw_mix_18_h,
  /* <fl2> */  input ccw_mix_19_h,
  /* <fk2> */  input ccw_mix_20_h,
  /* <fh2> */  input ccw_mix_21_h,
  /* <fj2> */  input ccw_mix_22_h,
  /* <fe2> */  input ccw_mix_23_h,
  /* <bm1> */  input ccw_mix_24_h,
  /* <bn1> */  input ccw_mix_25_h,
  /* <bp1> */  input ccw_mix_26_h,
  /* <bm2> */  input ccw_mix_27_h,
  /* <bl1> */  input ccw_mix_28_h,
  /* <bl2> */  input ccw_mix_29_h,
  /* <bj1> */  input ccw_mix_30_h,
  /* <bf2> */  input ccw_mix_31_h,
  /* <bh2> */  input ccw_mix_32_h,
  /* <bf1> */  input ccw_mix_33_h,
  /* <be2> */  input ccw_mix_34_h,
  /* <be1> */  input ccw_mix_35_h,
  /* <dj1> */ output ccw_odd_adr_par_h,
  /* <dm2> */ output ccw_wd0_req_h,
  /* <cf2> */ output ccw_wd1_req_h,
  /* <ef2> */ output ccw_wd2_req_h,
  /* <cr1> */ output ccw_wd3_req_h,
  /* <ar2> */ output ccw_wd_ready_l,
  /* <cl1> */  input ch_diag_04_l,
  /* <cm1> */  input ch_diag_05_l,
  /* <cu2> */  input ch_diag_06_l,
  /* <dt2> */  input ch_diag_read_b_l,
  /* <bu2> */  input ch_mb_req_inh_h,
  /* <bt2> */  input ch_mr_reset_b_h,
  /* <bp2> */  input ch_t0_l,
  /* <cr2> */  input clk_ccw_h,
  /* <bj2> */  input crc_act_flag_ena_l,
  /* <ck1> */  input crc_ccwf_en_l,
  /* <as2> */  input crc_mem_store_ena_l,
  /* <ee2> */  input crc_ram_adr_1r_l,
  /* <ed2> */  input crc_ram_adr_2r_l,
  /* <ea1> */  input crc_ram_adr_4r_l,
  /* <cc1> */  input diag_channel_clk_stop_h,
  /* <aj1> */  input diag_load_func_070_l,
  /* <dk1> */ output ebus_d00_e_h,
  /* <cf1> */ output ebus_d01_e_h,
  /* <eh2> */ output ebus_d02_e_h,
  /* <cs2> */ output ebus_d03_e_h,
  /* <dl1> */ output ebus_d04_e_h,
  /* <df2> */ output ebus_d05_e_h,
  /* <ap2> */  input mb0_hold_in_h,
  /* <ae2> */  input mb1_hold_in_h,
  /* <ad2> */  input mb3_hold_in_h
);

`include "ccw12.svh"

endmodule	// ccw12
