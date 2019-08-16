#!/usr/bin/env node

'use strict';

const CLA = require('command-line-args')
const COMPILE = require('./compile');


const optionDefinitions = [
  { name: 'trace-parse', alias: 'T', type: Boolean },
  { name: 'dump-ast', alias: 'A', type: Boolean },
  { name: 'verbose-errors', alias: 'V', type: Boolean },
  { name: 'check-nets', alias: 'C', type: Boolean },
  { name: 'check-undriven', alias: 'U', type: Boolean },
  { name: 'check-wire-or', alias: 'O', type: Boolean },
  { name: 'src', type: String, multiple: false, defaultOption: true },
];


const options = CLA(optionDefinitions);
const backplanes = COMPILE.compile(options);
