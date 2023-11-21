#include <stdlib.h>
#include <iostream>
#include <memory>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Vmc10136.h"

vluint64_t simT = 0;

int main(int argc, char** argv, char** env) {
  int Fbit = 0;
  static const unsigned MAX_SIM_TIME = 10000;
  Vmc10136_tb *dut = new Vmc10136_tb;

  Verilated::traceEverOn(true);
  VerilatedVcdC *m_trace = new VerilatedVcdC;
  dut->trace(m_trace, 5);
  m_trace->open("waveform.vcd");
  dut->done = 0;
  dut->clk = 0;

  while (simT < MAX_SIM_TIME && !dut->done) {
    dut->eval();
    m_trace->dump(simT);
    simT++;
    dut->clk = !dut->clk;
  }

  m_trace->close();
  delete dut;
  exit(EXIT_SUCCESS);
}
