#!/usr/bin/env node
'use strict';

const util = require('util');
const CMDR = require('commander').program;
const {compile} = require('./compile');

CMDR
  .option('-t, --trace-parse', `Print trace while parsing netlist`)
  .option('-a, --dump-ast', `Dump AST after parsing`)
  .option('-b, --dump-backplane', `Dump backplane slots and net name`)
  .option('-s, --dump-signals', `Dump signals list after parsing`)
  .option('-n, --dump-nets', `Dump netlist`)
  .option('-u, --dump-undriven', `Dump list of undriven nets`)
  .option('-o, --dump-wire-or', `Dump list of wire-ORed nets`)
  .option('-v, --verbose-errors', `Give more info for errors`)
  .argument('<src>', `Source file to start parsing`)
  .action((src, options) => {
    options.src = src;
    const backplanes = compile(options);
    console.log(`[done]`);
  })
  .parse();
