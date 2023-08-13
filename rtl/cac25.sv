module cac25(
  /* <cv2> */  input cache_adr_27_h,
  /* <da1> */  input cache_adr_28_h,
  /* <dp1> */  input cache_adr_29_h,
  /* <dv2> */  input cache_adr_30_h,
  /* <es1> */  input cache_adr_31_h,
  /* <cf1> */  input cache_adr_32_h,
  /* <ca1> */  input cache_adr_33_h,
  /* <bf1> */  input cache_adr_34_h,
  /* <br1> */  input cache_adr_35_h,
  /* <bs1> */  input cache_adr_35_l,
  /* <ff1> */ output cache_data_00_a_h,
  /* <fe2> */ output cache_data_00_b_h,
  /* <fe1> */ output cache_data_00_c_h,
  /* <ep2> */ output cache_data_01_a_h,
  /* <ep1> */ output cache_data_01_b_h,
  /* <er1> */ output cache_data_01_c_h,
  /* <es2> */ output cache_data_02_a_h,
  /* <eu2> */ output cache_data_02_b_h,
  /* <ev2> */ output cache_data_02_c_h,
  /* <df1> */ output cache_data_03_a_h,
  /* <df2> */ output cache_data_03_b_h,
  /* <de1> */ output cache_data_03_c_h,
  /* <dm1> */ output cache_data_04_a_h,
  /* <dm2> */ output cache_data_04_b_h,
  /* <dl2> */ output cache_data_04_c_h,
  /* <be2> */ output cache_data_05_a_h,
  /* <be1> */ output cache_data_05_b_h,
  /* <bf2> */ output cache_data_05_c_h,
  /* <bk1> */ output cache_data_06_a_h,
  /* <bl2> */ output cache_data_06_b_h,
  /* <bk2> */ output cache_data_06_c_h,
  /* <ar1> */ output cache_data_07_a_h,
  /* <ap2> */ output cache_data_07_b_h,
  /* <ar2> */ output cache_data_07_c_h,
  /* <bd2> */ output cache_data_08_a_h,
  /* <ba1> */ output cache_data_08_b_h,
  /* <bd1> */ output cache_data_08_c_h,
  /* <el1> */  input cache_wr_00_a_l,
  /* <ej1> */  input csh_0_00to17_sel_a_l,
  /* <ee1> */  input csh_1_00to17_sel_a_l,
  /* <bj2> */  input csh_2_00to17_sel_a_l,
  /* <bj1> */  input csh_3_00to17_sel_a_l,
  /* <dd1> */ output csh_par_bit_00_a_h,
  /* <fa1> */ output csh_par_bit_00_b_h,
  /* <fd1> */  input csh_par_bit_in_h,
  /* <fd2> */  input mem_to_cache_00_h,
  /* <er2> */  input mem_to_cache_01_h,
  /* <ff2> */  input mem_to_cache_02_h,
  /* <cm1> */  input mem_to_cache_03_h,
  /* <cp1> */  input mem_to_cache_04_h,
  /* <cl1> */  input mem_to_cache_05_h,
  /* <au2> */  input mem_to_cache_06_h,
  /* <av2> */  input mem_to_cache_07_h,
  /* <as2> */  input mem_to_cache_08_h
);

`include "cac25nets.svh"

endmodule	// cac25
