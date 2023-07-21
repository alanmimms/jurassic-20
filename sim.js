#!/usr/bin/env node
'use strict';

const util = require('util');
const CMDR = require('commander').program;
const {compile} = require('./compile');

CMDR
  .showHelpAfterError()
  .option('-a, --dump-ast', `Dump AST after parsing`)
  .option('-b, --dump-backplane', `Dump backplane slots and net names`)
  .option('-c, --dump-cram', `Dump CRAM definitions`)
  .option('-n, --dump-nets', `Dump netlist`)
  .option('-o, --dump-wire-or', `Dump list of wire-ORed nets`)
  .option('-p, --dump-pins', `Dump board pins and backplane pins for each board`)
  .option('-s, --dump-signals', `Dump signals list after parsing`)
  .option('-t, --trace-parse', `Print trace while parsing netlist`)
  .option('-u, --dump-undriven', `Dump list of undriven nets`)
  .option('-v, --verbose-errors', `Give more info for errors`)
  .option('-V, --dump-verilog', `Dump Verilogified symbols`)
  .option('-w, --dump-wires', `Dump list of wires on each board`)
  .argument('[src]', `Source file to start parsing`, `kl10pv.backplane`)
  .action((src, options) => {
    options.src = src;
    const backplanes = compile(options);
    console.log(`[done]`);
  })
  .parse();
