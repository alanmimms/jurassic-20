'use strict';

const _ = require('lodash');
const fs = require('fs');
const util = require('util');
const PEG = require('pegjs');

const logic = require('./logic.js');

const dumpAST = true;


let parser = PEG.buildParser(fs.readFileSync('netlist.pegjs', 'utf8'), {
  output: 'parser',
//  trace: true,
});

const dpa = fs.readFileSync('dpa.board', 'utf8');

let ast;

try {
  ast = parser.parse(dpa);
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

//console.log('ast:', util.inspect(ast, {depth: 9, colors: false}));

if (dumpAST) {
  let f = fs.openSync('before.evaluation', 'w');
  fs.writeSync(f, util.inspect(ast, {depth: 9999}));
  fs.closeSync(f);
}


var macroEnv = {n: 12};
var netRefs = {};

expandMacros(ast);


// Walk the entire AST. Under all 'Pin' nodes evaluate and expand all
// '[]' nodes and join any adjacent IDchunks with them to form a
// single 'ID' node with attribute 'name'.
var net, pin, chip, page, board;
function expandMacros(ast) {

  if (!ast) return;

  switch (ast.t) {
  case 'Chip':
    chip = ast;
    chip.page = page;
    chip.logic = logic[chip.type];
//    console.log(`Chip ${util.inspect(chip)}`);

    if (!chip.logic) {
      // Provide dummy entry just so we can go on
      chip.logic = {'<': [], '>': [], '<>': []};
      console.log(`${page.name}.${chipname} undefined logic device '${chip.type}'`);
    }
    
    //  console.log(`\n${page.name}.${chip.name}: ${chip.type} ${chip.desc}`);
    chip.pins.forEach(k => expandMacros(k));
    break;

  case 'Page':
    page = ast;
    page.board = board;
    //    console.log(`\nPage ${page.name}, pdfRef ${page.pdfRef}`);
    page.nodes.forEach(k => expandMacros(k));
    break;

  case 'Board':
    board = ast;
    ast.pages.forEach(k => expandMacros(k));
    break;

  case 'Pin':
    pin = ast;
    pin.chip = chip;
    net = '';

    switch (pin.net.t) {
    case '[]':		// Macro
      net += evalExpr(pin.net);
      break;

    case 'IDchunk':	// Piece of an identifier
      net += pin.net.name;
      console.log(`IDchunk net='${net}'`);
      break;

    case '%NC%':
      net += '%NC%';
      break;

    case '#':
      net += pin.net.value;
      break;

    case 'ID':
      net += pin.net.chunks.map(c => evalExpr(c)).join('');
      break;

    default:
      break;
    }

    if (!chip.logic[pin.dir] || chip.logic[pin.dir].indexOf(pin.name) < 0)
      console.log(`  ${chip.name} undefined pin ${pin.name} ${pin.dir} ` +
		  `for ${chip.type}`);

    pin.net = net;
    
    // We want netRefs to be an object whose properties are the net
    // names. Each property value is an object whose names are the pin
    // directions: '<', '>', and '<>'. The value of this property is
    // an object whose properties (and, to be complete here, its
    // values as well) are the pins attached to the net for the
    // associated direction.
    if (!netRefs[net]) netRefs[net] = {};
    if (!netRefs[net][pin.dir]) netRefs[net][pin.dir] = {};
    netRefs[net][pin.dir][pin] = pin;
    break;

  default:
    console.log(`Unrecognized AST node type '${ast.t}'.`);
    break;
  }
}


// For the given AST subtree evaluate and expand any macro 'id' nodes
// with the corresponding value from 'macroEnv' and numerically
// evaluate any expression. Returns the full expansion of the
// resulting collapsed tree.
function evalExpr(t) {
  let result;

  if (!t || !t.t) debugger;

  switch (t.t) {
  case '[]':

    // Two cases:
    // 
    // 1. t.ids is an empty array, in which case t.head is a (possibly
    // complex) macro to be expanded.
    //
    // 2. t.ids is a non-empty array, in which case t.head is a simple
    // expression macro whose value is the 1-origin member of t.ids[]
    // to expand. Note that this t.ids[n-1] value might be a complex
    // macro.
    result = evalExpr(t.head);

    if (t.ids.length) {		// It's a selector
      result = evalExpr(t.ids[+result - 1]);
    }

    break;

  case '+':
  case '-':
  case '/':
  case '*':
    result = Math.trunc(eval(evalExpr(t.l) + t.t + evalExpr(t.r)));
    break;

  case 'IDchunk':
  case 'id':
    result = macroEnv[t.name];
    if (result === undefined) result = t.name;
    break;

  case '#':
    result = t.value;
    break;

  default:
    console.log(`Unhandled subtree node type in [] macro: '${util.inspect(t, {depth: 999})}'.`);
    result = '<coding error>';
    break;
  }

//  console.log(`evalExpr(${util.inspect(t)}) result '${result}'`);
  return result;
}


if (dumpAST) {
  let f = fs.openSync('after.evaluation', 'w');
  fs.writeSync(f, util.inspect(ast, {depth: 9999}));
  fs.closeSync(f);
}


// Check each net for more than one driving pin.
Object.keys(netRefs)
  .forEach(net => {
    if (net === '0' || net === '1' || net === '%NC%') return;
    const driving = netRefs[net]['>'];
    if (!driving) return;
    const n = Object.keys(driving).length;
    if (n === 1) return;
    console.log(`Net '${net}' has ${n} driving pins: ` +
		(n ? Object.keys(driving).map(d => d.chip.name + '.' + d.name) : '<none>'));
  });


/*
const it = 'internal-e33-3 3';
console.log(it + ':', require('util').inspect(netRefs[it]['>'], {depth: 1}));
 */

console.log(`Check pins vs logic:`);



console.log(`Unconnected node names:`);
