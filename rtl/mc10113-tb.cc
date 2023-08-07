#include <stdlib.h>
#include <iostream>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Vmc10113.h"

#define MAX_SIM_TIME 515
vluint64_t sim_time = 0;

int main(int argc, char** argv, char** env) {
  Vmc10113 *dut = new Vmc10113;

  Verilated::traceEverOn(true);
  VerilatedVcdC *m_trace = new VerilatedVcdC;
  dut->trace(m_trace, 5);
  m_trace->open("waveform.vcd");

  while (sim_time < MAX_SIM_TIME) {
    dut->a1 = !!(sim_time & 1);
    dut->a2 = !!(sim_time & 2);
    dut->b1 = !!(sim_time & 4);
    dut->b2 = !!(sim_time & 8);
    dut->c1 = !!(sim_time & 16);
    dut->c2 = !!(sim_time & 32);
    dut->d1 = !!(sim_time & 64);
    dut->d2 = !!(sim_time & 128);
    dut->ne = !!(sim_time & 256);
    dut->eval();
    m_trace->dump(sim_time);
    sim_time++;
  }

  m_trace->close();
  delete dut;
  exit(EXIT_SUCCESS);
}
