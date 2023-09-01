#!/usr/bin/env node
'use strict';

const util = require('util');
const CMDR = require('commander').program;
const {compile, doTests} = require('./compile');

CMDR
  .showHelpAfterError()
  .option('-a, --dump-ast', `Dump AST after parsing`)
  .option('-b, --dump-backplane', `Dump backplane slots and net names`)
  .option('-c, --dump-cram', `Dump CRAM definitions`)
  .option('-g, --genSV', `Generate SystemVerilog code for backplane and modules`)
  .option('-n, --dump-nets', `Dump netlist`)
  .option('-o, --dump-wire-or', `Dump list of wire-ORed nets`)
  .option('-p, --dump-pins', `Dump board pins and backplane pins for each board`)
  .option('-s, --dump-slots', `Dump slot signals after parsing`)
  .option('-t, --trace-parse', `Print trace while parsing netlist`)
  .option('-u, --dump-undriven', `Dump list of undriven nets`)
  .option('-v, --verbose-errors', `Give more info for errors`)
  .option('-V, --dump-verilog', `Dump Verilogified symbols`)
  .option('-w, --dump-wires', `Dump list of wires on each board`)
  .option('-T, --run-tests', `Run built-in unit tests`)
  .argument('[src]', `Source file to start parsing`, `kl10pv.backplane`)
  .action((src, options) => {
    options.src = src;
    if (options.runTests) doTests();
    const backplanes = compile(options);
    console.log(`[done]`);
  })
  .parse();
