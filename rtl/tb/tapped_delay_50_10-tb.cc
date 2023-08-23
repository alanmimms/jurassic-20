#include <stdlib.h>
#include <iostream>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Vtapped_delay_50_10.h"

vluint64_t simT = 0;

#define ALL_BIT_FIELDS \
  DO1(in)

int main(int argc, char** argv, char** env) {

#define DO1(F)	const vluint64_t F##bit = 1ull << Fbit++;
  vluint64_t Fbit = 1;
  ALL_BIT_FIELDS
#undef DO1

  static const unsigned MAX_SIM_TIME = (1ull << Fbit) + 3;
  Vtapped_delay_50_10 *dut = new Vtapped_delay_50_10;

  Verilated::traceEverOn(true);
  VerilatedVcdC *m_trace = new VerilatedVcdC;
  dut->trace(m_trace, 5);
  m_trace->open("waveform.vcd");

  while (simT < MAX_SIM_TIME) {
#define DO1(F)	do {dut->F = !!(simT & F##bit); } while (0);
    ALL_BIT_FIELDS
#undef DO1
    dut->eval();
    m_trace->dump(simT);
    simT++;
  }

  m_trace->close();
  delete dut;
  exit(EXIT_SUCCESS);
}
