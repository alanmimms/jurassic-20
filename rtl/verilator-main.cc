#include <cstdlib>
#include <iostream>
#include <signal.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <signal.h>

#include <verilated.h>
#include "Vkl10pv.h"

#if VM_TRACE
#include <verilated_vcd_c.h>
#endif


static const double nsPerTick = 1.0;


extern "C" void FEinitial(double nsPerTick);
extern "C" void FEfinal(uint64_t ns);


void DTEinitial() {
  FEinitial(nsPerTick);
}


void DTEfinal(uint64_t ns) {
  FEfinal(ns);
}


int main(int argc, char **argv) {
  const std::unique_ptr<VerilatedContext> contextp{new VerilatedContext};
  contextp->traceEverOn(true);
  contextp->commandArgs(argc, argv);
  contextp->timeunit(-9);	// Timeunit is ns

  const std::unique_ptr<Vkl10pv> top{new Vkl10pv{contextp.get(), "top"}};

  VerilatedVcdC* trace = nullptr;
#if VM_TRACE
  const char* flag = contextp->commandArgsPlusMatch("trace");

  if (true || 0 == std::strcmp(flag, "+trace")) {
    contextp->traceEverOn(true);
    trace = new VerilatedVcdC;
    top->trace(trace, 99);
    trace->spTrace()->set_time_resolution("ns");
    trace->spTrace()->set_time_unit("ns");
    trace->open("kl10pv-trace.vcd");
  }
#endif

  // Turn on the Front End.
  DTEinitial();

  while (!contextp->gotFinish()) {
    top->clk60 = 0;
    top->eval();
    if (trace) trace->dump(contextp->time());
    contextp->timeInc(5);

    top->clk60 = 1;
    top->eval();
    if (trace) trace->dump(contextp->time());
    contextp->timeInc(5);
  }

  DTEfinal(contextp->time());

  // Kill our child (the FE) and wait for it to exit.
  kill(0, SIGINT);
  wait(NULL);

  return 0;
}
