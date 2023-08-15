module ccl11(
  /* <be2> */ output ccl_act_flag_clr_l,
  /* <bd1> */ output ccl_act_flag_req_l,
  /* <ad1> */ input  ccl_act_flag_req_l,
  /* <fc1> */ output ccl_af_wd0_req_h,
  /* <fa1> */ output ccl_af_wd1_req_h,
  /* <fh2> */ output ccl_af_wd2_req_h,
  /* <fj2> */ output ccl_af_wd3_req_h,
  /* <ee1> */ output ccl_alu_minus_l,
  /* <aj2> */ output ccl_alu_plus_l,
  /* <ej1> */ output ccl_buf_adr_3_h,
  /* <bt2> */ output ccl_ccw_buf_wr_l,
  /* <cu2> */ output ccl_ccw_reg_load_h,
  /* <aj1> */ output ccl_ccwf_clr_h,
  /* <av2> */ output ccl_ccwf_clr_l,
  /* <ek2> */ output ccl_ccwf_req_h,
  /* <bs2> */ output ccl_ch_buf_wr_en_l,
  /* <dk2> */ output ccl_ch_load_mb_l,
  /* <ee2> */ output ccl_ch_mb_sel_1_h,
  /* <ds2> */ output ccl_ch_mb_sel_2_h,
  /* <dl2> */ output ccl_ch_test_mb_par_l,
  /* <eh2> */ output ccl_chan_ept_h,
  /* <ar1> */ output ccl_chan_ept_l,
  /* <dv2> */ output ccl_chan_req_h,
  /* <df2> */ output ccl_chan_req_l,
  /* <dd1> */ output ccl_chan_to_mem_h,
  /* <df1> */ output ccl_chan_to_mem_l,
  /* <fv2> */ output ccl_cons_0_h,
  /* <ft2> */ output ccl_cons_1_h,
  /* <fu2> */ output ccl_cons_2_h,
  /* <ef1> */ output ccl_csh_chan_cyc_h,
  /* <cp2> */ output ccl_data_reverse_h,
  /* <ae2> */ output ccl_err_req_l,
  /* <ba1> */ output ccl_error_h,
  /* <bs1> */ output ccl_hold_mem_h,
  /* <er2> */ output ccl_last_xfer_err_in_h,
  /* <ct2> */ output ccl_load_ac_h,
  /* <cs2> */ output ccl_load_ac_l,
  /* <el1> */ output ccl_mb_cyc_t2_l,
  /* <ek1> */ output ccl_mb_req_t2_l,
  /* <bm1> */ output ccl_mb_rip_h,
  /* <bm2> */ output ccl_mb_rip_l,
  /* <aa1> */ output ccl_mem_err_latch_l,
  /* <ep1> */ output ccl_mem_store_req_h,
  /* <dl1> */ output ccl_mem_store_req_l,
  /* <cf2> */ output ccl_mix_mb_sel_h,
  /* <dr2> */ output ccl_odd_wc_par_h,
  /* <ec1> */ output ccl_op_load_h,
  /* <cm1> */ output ccl_op_load_l,
  /* <bp2> */ output ccl_ram_req_l,
  /* <em2> */ output ccl_req_ctr_en_l,
  /* <cn1> */ output ccl_stSlres_intr_a_h,
  /* <de2> */ output ccl_start_mem_l,
  /* <cl1> */ output ccl_wcEq0_in_h,
  /* <af2> */ output ccl_wcEq0_in_l,
  /* <cl2> */ output ccl_wcEq0_l,
  /* <fr2> */ output ccl_wcEq1_h,
  /* <fr1> */ output ccl_wcEq2_h,
  /* <fs1> */ output ccl_wcEq3_h,
  /* <ed1> */ output ccl_wc_ge4_l,
  /* <bu2> */ output ccl_wd_taken_h,
  /* <ej2> */ output ccl_zero_fill_h,
  /* <as1> */ output ccl_zero_fill_l,
  /* <ca1> */ input  ccw_act_flag_req_ena_h,
  /* <cm2> */ output ccw_buf_00_in_h,
  /* <dr1> */ output ccw_buf_00_in_l,
  /* <ds1> */ output ccw_buf_01_in_h,
  /* <dp1> */ output ccw_buf_01_in_l,
  /* <ea1> */ output ccw_buf_02_in_h,
  /* <dm2> */ output ccw_buf_02_in_l,
  /* <fs2> */ output ccw_buf_03_in_h,
  /* <fp2> */ output ccw_buf_04_in_h,
  /* <fn1> */ output ccw_buf_05_in_h,
  /* <fm1> */ output ccw_buf_06_in_h,
  /* <fj1> */ output ccw_buf_07_in_h,
  /* <fk2> */ output ccw_buf_08_in_h,
  /* <fk1> */ output ccw_buf_09_in_h,
  /* <fl2> */ output ccw_buf_10_in_h,
  /* <fl1> */ output ccw_buf_11_in_h,
  /* <fm2> */ output ccw_buf_12_in_h,
  /* <fp1> */ output ccw_buf_13_in_h,
  /* <cd2> */ input  ccw_ccwf_req_ena_h,
  /* <ep2> */ input  ccw_cha_34_h,
  /* <en1> */ input  ccw_cha_35_h,
  /* <bc1> */ input  ccw_mem_adrEq0_l,
  /* <bv2> */ input  ccw_mem_store_ena_h,
  /* <cj2> */ input  ccw_mix_00_h,
  /* <ck2> */ input  ccw_mix_01_h,
  /* <ck1> */ input  ccw_mix_03_h,
  /* <du2> */ input  ccw_mix_03_h,
  /* <dn1> */ input  ccw_mix_04_h,
  /* <dt2> */ input  ccw_mix_05_h,
  /* <fd1> */ input  ccw_mix_06_h,
  /* <fd2> */ input  ccw_mix_07_h,
  /* <er1> */ input  ccw_mix_08_h,
  /* <es2> */ input  ccw_mix_09_h,
  /* <fe2> */ input  ccw_mix_10_h,
  /* <ff2> */ input  ccw_mix_11_h,
  /* <et2> */ input  ccw_mix_12_h,
  /* <ev2> */ input  ccw_mix_13_h,
  /* <dj1> */ input  ccw_wd_ready_l,
  /* <cc1> */ input  ch_ctom_l,
  /* <da1> */ input  ch_diag_04_l,
  /* <dc1> */ input  ch_diag_05_l,
  /* <de1> */ input  ch_diag_06_l,
  /* <dd2> */ input  ch_diag_read_a_l,
  /* <an1> */ input  ch_done_intr_h,
  /* <am2> */ input  ch_done_intr_l,
  /* <ch2> */ input  ch_reset_intr_l,
  /* <cr1> */ input  ch_reverse_h,
  /* <cj1> */ input  ch_start_intr_l,
  /* <as2> */ input  ch_t0_l,
  /* <at2> */ input  ch_t1_l,
  /* <au2> */ input  ch_t2_l,
  /* <ap2> */ input  ch_t3_l,
  /* <ah2> */ input  chan_adr_par_err_l,
  /* <ak2> */ input  chan_nxm_err_l,
  /* <bd2> */ input  chan_par_err_l,
  /* <cr2> */ input  clk_ccl_h,
  /* <em1> */ input  crc_act_ctr_0_h,
  /* <dh2> */ input  crc_act_ctr_1_h,
  /* <dj2> */ input  crc_act_ctr_2_h,
  /* <ef2> */ input  crc_act_ctr_2r_l,
  /* <ce2> */ input  crc_mb_cyc_h,
  /* <bl2> */ input  crc_mb_cyc_l,
  /* <eu2> */ input  crc_ovn_err_in_h,
  /* <br1> */ input  crc_ram_adr_1r_h,
  /* <bn1> */ input  crc_ram_adr_2r_h,
  /* <bp1> */ input  crc_ram_adr_4r_h,
  /* <bf2> */ input  crc_ram_cyc_l,
  /* <dk1> */ input  crc_req_d_h,
  /* <br2> */ input  crc_req_e_l,
  /* <ar2> */ input  crc_reset_l,
  /* <el2> */ input  crc_reverse_in_h,
  /* <fe1> */ input  crc_rh20_err_in_h,
  /* <es1> */ input  crc_short_wc_err_h,
  /* <ad2> */ input  crc_wr_ram_l,
  /* <cs1> */ input  csh_chan_cyc_a_h,
  /* <dp2> */ output ebus_d00_e_h,
  /* <ed2> */ output ebus_d02_e_h,
  /* <cv2> */ output ebus_d03_e_h,
  /* <al2> */ input  mr_reset_05_h
);

`include "ccl11nets.svh"

endmodule	// ccl11
