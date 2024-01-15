#!/usr/bin/env node
'use strict';

// Read (from stdin) the klx.no-formfeeds.listing file format starting
// at the `(U) J` field symbols and generate (to stdout) an "enum" to
// use with `cra-adr` and `cra-loc` bus in gtkwave.

const util = require('util');
const readline = require('readline');

const DEBUG = false;

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
  terminal: false,
});

// Symbols and their addresses.
const syms = {};

const lineNumRE = /\s+; (?<lineNum>\d+)\s+/;
const symRE = /((?<sym>[-A-Z.#+_][-A-Z0-9.#+_]+):)/;
const ucodeRE = /^((?<type>[UD]) (?<addr>[0-7]+), (?<ucode>[0-7]+,[0-7]+,[0-7]+,[0-7]+,[0-7]+,[0-7]+,[0-7]+))?/;


// Name of most recent label.
let lastLabel = null;


rl.once('close', () => {
  console.log(Object.entries(syms).map(([sym, addr]) => `${addr} ${sym}`).join('\n'));
});

rl.on('line', line => {
  let m;

  // Remove trailing comments
//  line = line.replace(/\s*;.*$/, '');

  // Ignore lines each of these matches but clear multiLine if we see them.
  if (M(/^\s+;;\d+.*/) ||			// Lines disabled because .IF false
      M(RE(lineNumRE, /\./, symRE)) ||		// Lines with assembler directives
      M(RE(lineNumRE, /[0-7]+:.*/)) ||		// Lines that set the microPC
      M(RE(lineNumRE, /=[0-7\*]+.*/)) ||	// Lines that constrain the microPC
      M(RE(lineNumRE, /$/)))			// Blank lines
  {
    lastLabel = null;
    return;
  }

  // Match a possibly multiple-line word of microcode.
  // This might or might not have the label name for this address.
  if ((m = M(RE(ucodeRE, lineNumRE, symRE, '?')))) {
    if (DEBUG) console.log(`
<<<${line}>>>
m=${util.inspect(m)}`);

    if (m.groups.addr && lastLabel) syms[lastLabel] = m.groups.addr;
    lastLabel = m.groups.sym;
  }


  function M(re) {
    const m = line.match(re);
    if (DEBUG && m) console.log(`match ${re}: ${util.inspect(m)}`);
    return m;
  }
});


// This allows nicer syntax for huge long REs. Allows strings as well as REs as parameters.
function RE(...R) {
  return new RegExp(R.map(r => r['source'] || r).join(''));
}
