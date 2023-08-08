#include <stdlib.h>
#include <iostream>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Vmc10109.h"

#define MAX_SIM_TIME 133
vluint64_t sim_time = 0;

int main(int argc, char** argv, char** env) {
  Vmc10109 *dut = new Vmc10109;

  Verilated::traceEverOn(true);
  VerilatedVcdC *m_trace = new VerilatedVcdC;
  dut->trace(m_trace, 5);
  m_trace->open("waveform.vcd");

  while (sim_time < MAX_SIM_TIME) {
    dut->a1 = !!(sim_time & 1);
    dut->a2 = !!(sim_time & 2);
    dut->a3 = !!(sim_time & 4);
    dut->a4 = !!(sim_time & 8);
    dut->b1 = !!(sim_time & 16);
    dut->b2 = !!(sim_time & 32);
    dut->b3 = !!(sim_time & 32);
    dut->b4 = !!(sim_time & 32);
    dut->b5 = !!(sim_time & 32);
    dut->eval();
    m_trace->dump(sim_time);
    sim_time++;
  }

  m_trace->close();
  delete dut;
  exit(EXIT_SUCCESS);
}
