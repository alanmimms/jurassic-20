'use strict';

// TODO: Saving ASTs to before and after files happens inside the
// *.board loop. This needs to be done globally after all boards are
// processed.

const _ = require('lodash');
const fs = require('fs');
const util = require('util');
const PEG = require('pegjs');

const logic = require('./logic.js');

const dumpAST = true;

let netRefs = {};


let parser = PEG.buildParser(fs.readFileSync('netlist.pegjs', 'utf8'), {
  output: 'parser',
//  trace: true,
});

let boards = process.argv.slice(2).map(filename => {
  let fullAST;

  try {
    console.log(`Compiling '${filename}'.`);
    fullAST = parser.parse(fs.readFileSync(filename, 'utf8'));
  } catch (e) {
    console.log("ERROR: Parsing Failure:", e.message);

    if (e.location) {
      console.log('       start:', e.location.start,
		  '\n         end:', e.location.end);
    } else {
      console.log('Exception:', util.inspect(e));
    }

    process.exit(1);
  }

  if (dumpAST) {
    let f = fs.openSync('before.evaluation', 'w');
    fs.writeSync(f, util.inspect(fullAST, {depth: 9999}));
    fs.closeSync(f);
  }


  let context = {};

  // `a` appears to be a setting to allow us to emulate a KL10A CPU
  // when a==1.
  //
  // `n` is the number of boards of the particular type being
  // compiled. This will eventually be driven by per-board population
  // values as we progress.
  let macroEnv = {
    n: 12, 
    a: 2,			// KL10B 50MHz clock
  };

  expandMacros(fullAST, macroEnv, context);


  if (dumpAST) {
    let f = fs.openSync('after.evaluation', 'w');
    fs.writeSync(f, util.inspect(fullAST, {depth: 9999}));
    fs.closeSync(f);
  }
});

////////////////////////////////////////////////////////////////////////////////
let notDriven = [];

console.log(`Check nets for zero or more than one driving pin:`);
Object.keys(netRefs).forEach(net => {

  // These special nets don't need driving pins.
  if (net === '0' || net === '1' || net === '%NC%') return;

  const driving = netRefs[net]['~>'];

  if (!driving) {
    notDriven.push(net);
    return;
  }
  
  const n = Object.keys(driving).length;
  if (n === 1) return;
  console.log(`Net '${net}' has ${n} driving pins: ` +
	      (n ? Object.keys(driving).join(', ') : '<none>'));
});

console.log('Undriven nets:');

notDriven.sort().forEach(net => {
  console.log(`  '${net}' from ` + Object.keys(netRefs[net]['~<']).join(', '));
});

console.log(`\nCount of undriven nets: ${notDriven.length}.`);

////////////////////////////////////////////////////////////////////////////////
// Walk the entire AST. Under all 'Pin' nodes evaluate and expand all
// 'Macro' nodes and join any adjacent IDchunks with them to form a
// single 'ID' node with attribute 'name'.
function expandMacros(ast, macroEnv, cx) {

  if (!ast) return;

  switch (ast.t) {
  case 'Chip':
    cx.chip = ast;
    cx.chip.page = cx.page;
    cx.chip.board = cx.board;
    cx.chip.logic = logic[cx.chip.type];
//    console.log(`Chip ${util.inspect(chip)}`);

    if (!cx.chip.logic) {
      // Provide dummy entry just so we can go on
      cx.chip.logic = {'~<': [], '~>': [], '~<>': []};
      console.log(`======> ${cx.page.name}.${cx.chip.name} undefined logic device '${cx.chip.type}'`);
    }
    
    //  console.log(`\n${page.name}.${chip.name}: ${chip.type} ${chip.desc}`);
    cx.chip.pins.forEach(k => expandMacros(k, macroEnv, cx));
    break;

  case 'Page':
    cx.page = ast;
    cx.page.board = cx.board;
    //    console.log(`\nPage ${page.name}, pdfRef ${page.pdfRef}`);
    cx.page.chips.forEach(k => expandMacros(k, macroEnv, cx));
    break;

  case 'Board':
    cx.board = ast;
    ast.pages.forEach(k => expandMacros(k, macroEnv, cx));
    break;

  case 'Pin':
    cx.pin = ast;
    cx.pin.chip = cx.chip;
    cx.pin.fullName = cx.pin.chip.page.name + '.' + cx.pin.chip.name + '.' + cx.pin.name;
    cx.pin.symbol = Symbol(cx.pin.fullName);
    cx.net = '';

    switch (cx.pin.net.t) {
    case 'Macro':
      if (cx.pin.fullName === 'DP01.e53.d7') debugger;
      console.log(`Macro pin.fullName=${cx.pin.fullName}`);
      cx.net += evalExpr(cx.pin.net, macroEnv);	// Handles selectors and simple macros
      break;

    case 'IDList':
      cx.net = cx.pin.net.list.map(id => evalExpr(id, macroEnv)).join('');
      break;

    case 'IDChunk':
      cx.net += cx.pin.net.name;
      break;

    case 'NoConnect':
      cx.net += '%NC%';
      break;

    case 'Value':
      cx.net += cx.pin.net.value;
      break;

    default:
      console.log(`Unhandled AST type in evalExpr: ast=${util.inspect(ast, {depth: 99})}`);
      break;
    }

    if (!cx.chip.logic[cx.pin.dir] || cx.chip.logic[cx.pin.dir].indexOf(cx.pin.name) < 0)
      console.log(`======>  ${cx.chip.name} undefined pin ${cx.pin.name} ${cx.pin.dir} ` +
		  `for ${cx.chip.type}`);

    cx.pin.netName = cx.net;
    if (cx.net === '') 
      console.log(`Pin ${cx.pin.fullName}  net=${util.inspect(cx.pin.net, {depth: 9})}`);
    
    // We want netRefs to be an object whose properties are the net
    // names. Each property value is an object whose names are the pin
    // directions: '~<', '~>', and '~<>'. The value of this property
    // is an object whose properties (and, to be complete here, its
    // values as well) are the pins attached to the net for the
    // associated direction.
    if (!netRefs[cx.net]) netRefs[cx.net] = {};
    if (!netRefs[cx.net][cx.pin.dir]) netRefs[cx.net][cx.pin.dir] = {};
    netRefs[cx.net][cx.pin.dir][cx.pin.fullName] = cx.pin;
    break;

  default:
    console.log(`Unrecognized AST node type '${ast.t}'.`);
    break;
  }
}


// For the given AST subtree evaluate and expand any macro nodes
// with the corresponding value from 'macroEnv' and numerically
// evaluate any expression. Returns the full expansion of the
// resulting collapsed tree.
function evalExpr(t, macroEnv) {
  let result;

  if (!t || !t.t) debugger;

  switch (t.t) {
  case 'Macro':
    // Two cases:
    // 
    // 1. t.ids is an empty array, in which case t.head is a (possibly
    // complex) macro to be expanded.
    //
    // 2. t.ids is a non-empty array, in which case t.head is a simple
    // expression macro whose value is the 1-origin member of t.ids[]
    // to expand. Note that this t.ids[n-1] value might be a complex
    // macro.
    result = evalExpr(t.head, macroEnv);

    if (t.ids.list.length) {		// It's a selector
      const sel = result;
//      console.log(`Selector result=${result}  t=${util.inspect(t, {depth: null})}`);
      const selected = t.ids.list[+result - 1];

      if (result < 1 || selected == null) {
	console.log(`ERROR: Selector produces undefined result at\n${util.inspect(t.loc)}`);
	result = '%NC%';
      } else {
	result = evalExpr(selected, macroEnv);
      }
    }

    break;

  case '+':
  case '-':
  case '/':
  case '*':
    result = Math.trunc(eval(evalExpr(t.l, macroEnv) + t.t + evalExpr(t.r, macroEnv)));
    break;

  case 'IDList':
    result = t.list.map(id => evalExpr(id, macroEnv)).join('');
    break;

  case 'IDChunk':
    result = macroEnv[t.name];
    if (result === undefined) result = t.name;
    break;

  case 'Value':
    result = t.value;
    break;

  default:
    console.log(`Unhandled subtree node type in ${t.t} macro: '${util.inspect(t, {depth: 999})}'.`);
    result = '<coding error>';
    break;
  }

//  console.log(`evalExpr(${util.inspect(t)}) result '${result}'`);
  return result;
}

