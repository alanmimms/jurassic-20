'use strict';

const _ = require('lodash');
const fs = require('fs');
const util = require('util');
const PEG = require('pegjs');

const logic = require('./logic.js');

const dumpAST = true;


let parser = PEG.buildParser(fs.readFileSync('netlist.pegjs', 'utf8'), {
  output: 'parser',
  trace: true,
});

const dpa = fs.readFileSync('dpa.board', 'utf8');

let ast;

try {
  ast = parser.parse(dpa);
} catch (e) {
  console.log("ERROR: Parsing Failure:", e.message, 
	      '\n       start:', e.location.start,
	      '\n         end:', e.location.end);
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
var net, dir, pin, chip, page;
function expandMacros(ast) {

  if (!ast) return;

  switch (ast.t) {
  case 'Chip':
    chip = ast;
    chip.logic = logic[chip.type];

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
    //    console.log(`\nPage ${page.name}, pdfRef ${page.pdfRef}`);
    page.nodes.forEach(k => expandMacros(k));
    break;

  case 'Board':
    ast.pages.forEach(k => expandMacros(k));
    break;

  case 'Pin':
    pin = ast;
    net = '';

    switch (pin.net.t) {
    case '[]':		// Macro
      net += evalExpr(pin.net.head);
      // XXX Add selector logic back here
      break;

    case 'IDchunk':	// Piece of an identifier
      net += pin.net.name;
      break;

    case '%NC%':
      net += '%NC%';
      break;

    case '#':
      net += pin.net.value;
      break;

    default:
      break;
    }

    if (!chip.logic[pin.dir] || chip.logic[dir].indexOf(pin.name) < 0)
      console.log(`  ${chip.name} undefined pin ${pin.name} ${pin.dir} ` +
		  `for ${chip.type}`);

    pin.net = net;
    
    if (!netRefs[net]) netRefs[net] = {[dir]: []};
    if (!netRefs[net][dir]) netRefs[net][dir] = {};
    netRefs[net][dir][pin] = pin;
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
  let kids = t.childs();

  switch (t.type()) {
  case '[]':

    if (kids.length > 1) {	// It's a selector
      let n = +evalExpr(kids[0]);
      return evalExpr(kids[n]);
    } else {			// It's a simple expression macro
      return evalExpr(kids[0]);
    }

  case '+':
  case '-':
  case '/':
  case '*':
    return Math.trunc(eval(+evalExpr(kids[0]) + t.type() + +evalExpr(kids[1])));

  case 'IDchunk':
  case 'id':
    let e = macroEnv[t.get('name')];
    if (e === undefined) e = t.get('name');
    return e;

  case '#':
    return t.get('value');

  default:
    console.log(`Unhandled subtree node type in [] macro: '${t.type()}'.`);
    break;
  }
}


if (dumpAST) {
  let f = fs.openSync('after.evaluation', 'w');
  fs.writeSync(f, util.inspect(ast, {depth: 9999}));
  fs.closeSync(f);
}


// Check each net for more than one driving pin.
Object.keys(netRefs)
  .filter(net => {
    if (!netRefs[net]['>']) return true;
    let nOuts = Object.keys(netRefs[net]['>']).length;
    return (nOuts !== 1);
  })
  .forEach(net => console.log(`${net} has zero or more than one driving pin`));


/*
const it = 'internal-e33-3 3';
console.log(it + ':', require('util').inspect(netRefs[it]['>'], {depth: 1}));
 */

console.log(`Check pins vs logic:`);



console.log(`Unconnected node names:`);
