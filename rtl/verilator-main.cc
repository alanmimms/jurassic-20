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


// Our top level clock frequency in Hz.
// 100MHz is easier to head-calculate than 60MHz.
static const double top_clkHz = 100.0e6;

// This is monotonically incremented as we run for each top_clk
// phase. From this we compute the value of contextp->time() based on
// top_clkHz.
static uint64_t nTicks = 0;

// This is the number of real ns between each top_clk phase.
static const double nsPerTick = 1000.0 / (top_clkHz/1.0e6) / 4.0;


// Returns rounded number of ns for the number of top_clk phases
// counted by nTicks.
static inline uint64_t nsFromTicks() {
  return (uint64_t) (0.5 + (double) nTicks * nsPerTick);
}


extern "C" void FEinitial(double nsPerTick);
extern "C" void FEfinal(uint64_t nsAtEndOfRun);


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
    top->eval();
    if (trace) trace->dump(contextp->time());

    ++nTicks;
    contextp->time(nsFromTicks());
    top->top_clk = !top->top_clk;
  }

  DTEfinal(contextp->time());

  // Kill our child (the FE) and wait for it to exit.
  kill(0, SIGINT);
  wait(NULL);

  return 0;
}
