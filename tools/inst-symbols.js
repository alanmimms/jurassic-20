#!/usr/bin/env node
'use strict';

// Generate (to stdout) an "enum" to use with `IR` bus in gtkwave.

const util = require('util');
const readline = require('readline');

const DEBUG = false;

const I = require('./instructions.js');

const list = I.map(([mne, op]) => `${op.toString(8).padStart(5, '0')} ${mne}`);

console.log(list.join('\n'));
