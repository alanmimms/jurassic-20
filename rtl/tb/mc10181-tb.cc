#include <stdlib.h>
#include <iostream>
#include <memory>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Vmc10181.h"

vluint64_t simT = 0;

int main(int argc, char** argv, char** env) {
  int Fbit = 0;
  static const unsigned MAX_SIM_TIME = 1000;
  Vmc10181 *dut = new Vmc10181;

  Verilated::traceEverOn(true);
  VerilatedVcdC *m_trace = new VerilatedVcdC;
  dut->trace(m_trace, 5);
  m_trace->open("mc10181-tb.vcd");

  // Test 1100 BOOLE=1 case: Should result in 0000.
  dut->s8 = 1;
  dut->s4 = 1;
  dut->s2 = 0;
  dut->s1 = 0;
  dut->boole = 1;

  while (simT < MAX_SIM_TIME) {
    dut->eval();
    m_trace->dump(simT);
    simT++;
  }

  m_trace->close();
  delete dut;
  exit(EXIT_SUCCESS);
}
