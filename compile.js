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


function parseNetList() {
  const netRefs = {};

  const parser = PEG.generate(fs.readFileSync('netlist.pegjs', 'utf8'), {
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
      n: '0o6',
      a: '0o2',			// KL10B 50MHz clock
    };

    expandMacros(fullAST, netRefs, macroEnv, context);

    if (dumpAST) {
      let f = fs.openSync('after.evaluation', 'w');
      fs.writeSync(f, util.inspect(fullAST, {depth: 9999}));
      fs.closeSync(f);
    }
  });

  return netRefs;
}


////////////////////////////////////////////////////////////////////////////////
// Walk through all net references and create an object whose property names
// are the net names and whose property values are arrays of {pin, dir, bpPin}.
function findConnectedNets(netRefs) {
  const connectedNets = {};
  
  Object.keys(netRefs).forEach(netName => {
    if (netName === '%NC%') return;
    connectedNets[netName] = [];

    Object.keys(netRefs[netName]).forEach(dir => {

      Object.values(netRefs[netName][dir]).forEach(pin => {
        const bpPin = pin.bpPin;
        connectedNets[netName].push({dir, pin, bpPin});
      });
    });
  });

  return connectedNets;
}


////////////////////////////////////////////////////////////////////////////////
// Complain if nets are not driven and not on the backplane connector
// or if driven by more than one pin.
function checkNetConnectivity(connectedNets) {

  console.log(`Check nets for proper connectivity:`);

  Object.keys(connectedNets).forEach(netName => {
    if (netName === '%NC%') return;
    if (netName === '0') return;
    if (netName === '1') return;

    const pins = connectedNets[netName];

    if (pins.length === 0) {
      console.log(`"${netName}" is not connected`);
    } else {
      const driving = pins.filter(pin => pin.dir === '~>' || pin.dir === '~<>');

      if (driving.length > 1) {
        console.log(`"${netName}" is driven by ${driving.length} pins`);
        console.log(`   ${util.inspect(driving)}`);
      } else if (driving.length === 0 && !pins.some(pin => pin.bpPin)) {
        console.log(`"${netName}" is not driven by any pin and is not backplane connected`);
      }
    }
  });
}


////////////////////////////////////////////////////////////////////////////////
// Walk the entire AST. Under all 'Pin' nodes evaluate and expand all
// 'Macro' nodes and join any adjacent IDchunks with them to form a
// single 'ID' node with attribute 'name'.
function expandMacros(ast, netRefs, macroEnv, cx) {


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
    cx.chip.pins.forEach(k => expandMacros(k, netRefs, macroEnv, cx));
    break;

  case 'Page':
    cx.page = ast;
    cx.page.board = cx.board;
    //    console.log(`\nPage ${page.name}, pdfRef ${page.pdfRef}`);
    cx.page.chips.forEach(k => expandMacros(k, netRefs, macroEnv, cx));
    break;

  case 'Board':
    cx.board = ast;
    ast.pages.forEach(k => expandMacros(k, netRefs, macroEnv, cx));
    break;

  case 'Pin':
    cx.pin = ast;
    cx.pin.chip = cx.chip;
    cx.pin.fullName = cx.pin.chip.page.name + '.' + cx.pin.chip.name + '.' + cx.pin.name;
    cx.pin.symbol = Symbol(cx.pin.fullName);
    cx.net = '';

    switch (cx.pin.net.t) {
    case 'Macro':
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
function evalExpr(t, macroEnv, isMath = false) {
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
    result = evalExpr(t.head, macroEnv, false);

    if (t.ids.list.length) {		// It's a selector
      const sel = result;
//      console.log(`Selector result=${result}  t=${util.inspect(t, {depth: null})}`);
      const selected = t.ids.list[+result - 1];

      if (result < 1 || selected == null) {
	console.log(`ERROR: Selector produces undefined result at\n${util.inspect(t.loc)}`);
	result = '%NC%';
      } else {
	result = evalExpr(selected, macroEnv, false);
      }
    }

    break;

  case '+':
  case '-':
  case '/':
  case '*':
    const expr = evalExpr(t.l, macroEnv, true) + t.t + evalExpr(t.r, macroEnv, true);
    result = '0o' + Math.trunc(eval(expr)).toString(8);
//    console.log(`Eval "${expr}" = ${result}`);
    break;

  case 'IDList':
    result = t.list.map(id => evalExpr(id, macroEnv, false)).join('');
    break;

  case 'IDChunk':
    result = macroEnv[t.name];
    if (result === undefined) result = t.name;
    break;

  case 'Value':
    result = `0o${t.value.toString(8)}`;
    break;

  default:
    console.log(`\
Unhandled subtree node type in ${t.t} macro: '${util.inspect(t, {depth: 999})}'.`);
    result = '<coding error>';
    break;
  }

//  console.log(`evalExpr(${util.inspect(t)}) result '${result}'`);
  if (!isMath) result = result.replace(/^0o/, '');
  return result;
}


const netRefs = parseNetList();
const connectedNets = findConnectedNets(netRefs);
checkNetConnectivity(connectedNets);
