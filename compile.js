'use strict';

const fs = require('fs');
const util = require('util');
const PEG = require('pegjs');

const logic = require('./logic.js');

// Provided by caller of `compile()`.
var options;


function parseFile(parser, filename) {
  let fileAST;

  try {
    fileAST = parser.parse(fs.readFileSync(filename, 'utf8'));
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

  return fileAST;
}


function dumpAST(ast, name, stage) {
  if (!options.dumpAst) return;

  const f = fs.openSync(`${name}.${stage}.evaluation`, 'w');
  fs.writeSync(f, util.inspect(ast, {depth: 9999}));
  fs.closeSync(f);
}



function parseBackplanes(parser) {
  const filename = options.src;
  const bp = parseFile(parser, filename)[0];

  console.log(`Backplane ${bp.name}:`);
  dumpAST(bp, bp.name, 'before');

  const bpMacros = bp.macros || [];
  const bpMacroDesc = bpMacros.map(macro => `${macro.id}=${macro.value}`).join (' ');
  const bpMacroEnv = {};

  bpMacros.forEach(macro => bpMacroEnv[macro.id] = macro.value);

  // For each slot, (re)parse the board definition and expand its
  // macros for the slot (and backplane, and CPU type) specifics.
  bp.slots.forEach(slot => {
    const board = slot.board;

    const macros = board.macros || [];
    const macroDesc = macros.map(macro => `${macro.id}=${macro.value}`).join (' ');
    const macroEnv = {...bpMacroEnv};

    macros.forEach(macro => macroEnv[macro.id] = macro.value);

    console.log(`  Slot ${slot.n}: ${board.id} ${macroDesc}`);

    const boardAST = parseFile(parser, `board/${board.id}.board`);
    expandMacros(boardAST, bp, macroEnv);
    slot.board = {... board, ... boardAST};
  });

  dumpAST(bp, bp.name, 'after');

  return bp;
}


////////////////////////////////////////////////////////////////////////////////
// Walk through all net references and create: {
//   netName1: [{pin, dir, bpPin},  ... ],  ...
// }
function gatherNetByName(bp) {
  bp.netByName = {};
  
  bp.slots
    .filter(slot => slot.board && slot.board.pages)
    .forEach(slot => {

      slot.board.pages.forEach(page => {

	page.chips.forEach(chip => {

	  chip.pins
	    .forEach(pin => {
	      if (!bp.netByName[pin.netName]) bp.netByName[pin.netName] = [];
	      bp.netByName[pin.netName].push(pin);
	    });
	});
      });
    });

  return bp.netByName;
}


////////////////////////////////////////////////////////////////////////////////
// Find all backplane pins in any given slot with more than one net name attached.
function defineBackplanePins(bp) {

  bp.slots
    .filter(slot => slot.board && slot.board.pages)
    .forEach(slot => {
      const board = slot.board;

      board.pages.forEach(page => {

	page.chips.forEach(chip => {

	  chip.pins
	    .filter(pin => pin.bpPin)
	    .forEach(pin => {
	      const bpPin = pin.bpPin;
	      const slotPin = slot.bpPins[bpPin];

	      if (slotPin && slotPin.netName && slotPin.name != pin.netName) {
		console.error(`\
Pin '${bpPin}' connected to "${pin.netName}" and "${slotPin.name}"`);
	      }

	      slot.bpPins[bpPin] = pin.netName;
	    });
	});
    });
  });
}


////////////////////////////////////////////////////////////////////////////////
// Complain if nets are not driven and not on the backplane connector
// or if driven by more than one pin.
function checkNetConnectivity(netByName) {

  console.log(`Check nets for proper connectivity:`);

  Object.keys(netByName).forEach(netName => {
    if (netName === '%NC%') return;
    if (netName === '0') return;
    if (netName === '1') return;

    const pins = netByName[netName];

    if (pins.length === 0) {
      console.log(`WARNING NOT CONNECTED: "${netName}" is not connected`);
    } else {
      const driving = pins.filter(pin => pin.dir === '~>');

      if (driving.length > 1) {

        if (options.checkWireOr) {
          console.log(`WARNING WIRE-OR: "${netName}" is wire-OR driven by ${driving.length} pins:`);
          if (options.verboseErrors) console.log(`    ${util.inspect(driving)}`);
        }
      } else if (driving.length === 0 && !pins.some(pin => pin.bpPin)) {

        if (options.checkUndriven) {
          console.log(`WARNING UNDRIVEN: "${netName}" is not driven by any pin and is not backplane connected:`);
          if (options.verboseErrors) console.log(`    ${util.inspect(pins)}`);
        }
      }
    }
  });
}


////////////////////////////////////////////////////////////////////////////////
// Walk the entire AST. Under all 'Pin' nodes evaluate and expand all
// 'Macro' nodes and join any adjacent IDchunks with them to form a
// single 'ID' node with attribute 'name'. The `cx` is the context for
// all expansion, accumulating the nets as we work through them.
function expandMacros(ast, nets, macroEnv, cx = {}) {


  if (!ast) return;

  switch (ast.nodeType) {
  case 'Chip':
    cx.chip = ast;
    cx.chip.page = cx.page;
    cx.chip.board = cx.board;
    cx.chip.logic = logic[cx.chip.type];

    if (!cx.chip.logic) {
      // Provide dummy entry just so we can go on
      cx.chip.logic = {'~<': [], '~>': []};
      console.log(`======> ${cx.page.name}.${cx.chip.name} undefined logic device '${cx.chip.type}'`);
    }
    
    cx.chip.pins.forEach(k => expandMacros(k, nets, macroEnv, cx));
    break;

  case 'Page':
    cx.page = ast;
    cx.page.board = cx.board;
    cx.page.chips.forEach(k => expandMacros(k, nets, macroEnv, cx));
    break;

  case 'Board':
    cx.board = ast;
    ast.pages.forEach(k => expandMacros(k, nets, macroEnv, cx));
    break;

  case 'Pin':
    cx.pin = ast;
    cx.pin.chip = cx.chip;
    cx.pin.fullName = cx.pin.chip.page.name + '.' + cx.pin.chip.name + '.' + cx.pin.pin;
    cx.pin.symbol = Symbol(cx.pin.fullName);
    cx.net = '';

    switch (cx.pin.net.nodeType) {
    case 'Macro':
      cx.net += evalExpr(cx.pin.net, macroEnv);	// Handles selectors and simple macros
      break;

    case 'IDList':
      cx.net = cx.pin.net.list.map(id => evalExpr(id, macroEnv)).join('').trim();
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

    if (!cx.chip.logic[cx.pin.dir] || !cx.chip.logic[cx.pin.dir][cx.pin.pin]) {
      console.log(`\
======>  ${cx.chip.name} undefined pin ${cx.pin.pin} ${cx.pin.dir} for ${cx.chip.type}`);
    }

    cx.pin.netName = cx.net;
    if (cx.net === '') 
      console.log(`Pin ${cx.pin.fullName}  net=${util.inspect(cx.pin.net, {depth: 9})}`);
    
    // We want nets to be an object whose properties are the net
    // names. Each property value is an object whose names are the pin
    // directions: '~<' and '~>'. The value of this property is an
    // object whose properties (and, to be complete here, its values
    // as well) are the pins attached to the net for the associated
    // direction.
    if (!nets[cx.net]) nets[cx.net] = {};
    if (!nets[cx.net][cx.pin.dir]) nets[cx.net][cx.pin.dir] = {};
    nets[cx.net][cx.pin.dir][cx.pin.fullName] = cx.pin;
    break;

  default:
    console.log(`Unrecognized AST node type '${ast.nodeType}'.`);
    break;
  }
}


// For the given AST subtree evaluate and expand any macro nodes
// with the corresponding value from 'macroEnv' and numerically
// evaluate any expression. Returns the full expansion of the
// resulting collapsed tree.
function evalExpr(t, macroEnv) {
  let result;

  if (!t || !t.nodeType) debugger;

  switch (t.nodeType) {
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
      const selected = t.ids.list[+result - 1];

      if (result < 1 || selected == null) {
	console.log(`ERROR: Selector produces undefined result t=\n${util.inspect(t, {depth:99})}`);
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
    // This is complicated by the need to keep the values as strings
    // and to evaluate to the number ofdigits which is the max of
    // the length of each of the operands.
    const L = evalExpr(t.l, macroEnv);
    const R = evalExpr(t.r, macroEnv);
    const digits = Math.max(L.length, R.length);
    const resultStr = Math.trunc(eval(`${parseInt(L, 10)} ${t.nodeType} ${parseInt(R, 10)}`));
    result = String(resultStr).padStart(digits, '0');
    break;

  case 'IDList':
    result = t.list.map(id => evalExpr(id, macroEnv)).join('').trim();
    break;

  case 'IDChunk':
    result = macroEnv[t.name];
    if (result === undefined) result = t.name;
    break;

  case 'Value':
    result = t.value;
    break;

  default:
    console.log(`\
Unhandled subtree node type in ${t.nodeType} macro: '${util.inspect(t, {depth: 999})}'.`);
    result = '<coding error>';
    break;
  }

  return result;
}


// bp.netByName = { netName1: [{pin, dir, bpPin},  ... ],  ... }
function dumpSignals(bp) {
  fs.writeFileSync('symbols.dump',
		   Object.entries(bp.netByName)
		   .filter(([net, pinList]) => pinList)
		   .sort((a, b) => ("" + a[0]).localeCompare(b[0], undefined, {numeric: true}))
		   .map(([net, pinList]) => `\
${net}: ${pinList.map(({pin, dir, bpPin}) => `${pin.fullName}${dir}${bpPin}`).join(', ')}`).join('\n'));
}


function compile(simOptions) {
  const backplanes = {};
  options = simOptions;

  const needCheck =
        options.checkNets ||
        options.checkWireOr ||
        options.checkUndriven;

  const parser = PEG.generate(fs.readFileSync('netlist.pegjs', 'utf8'), {
    output: 'parser',
    trace: options.traceParse,
  });

  // Parse the backplane definition and collapse the board page
  // substructure into a list of chips on the board.
  const bpAST = parseBackplanes(parser);
  const bp = {};

  bp.slots = bpAST.slots.reduce((slots, slot, slotNumber) => {

    const board = {
      slotNumber,
      id: slot.board.id,
      comments: slot.board.comments,
      location: slot.board.location,

      macros: (slot.board.macros || []).reduce((macros, mac) =>
	macros.concat(`${mac.id}=${mac.value}`),
	[]),

    };

    function astDirToDir(d) {
      return (d == '~<') ? 'in' : (d == '~>') ? 'out' : d;
    }

    board.chips = slot.board.pages.reduce((chips, page) => {

      page.chips.forEach(astChip => {

	if (chips[astChip.name]) {
	  console.error(`\
${slot.board.id}.${astChip.name} defined \
${util.inspect(astChip.location)} and previously \
${util.inspect(chips[astChip.name].location)}`);
	}

	chips[astChip.name] = {
	  type: astChip.type,
	  desc: astChip.desc,
	  page: page.name,
	  pdfRef: page.pdfRef,
	  location: astChip.location,
	  pins: astChip.pins,

	  pins: astChip.pins.map(pin => {
	    let result = {
	    pin: pin.pin,
	    dir: astDirToDir(pin.dir),
	    fullName: pin.fullName,
	    net: pin.netName,
	    location: pin.location,
	    };

	    if (pin.bpPin) {
	      result.bpPin = `${slot.board.id}.${pin.bpPin.replace(/[{}]/g, '')}[${slotNumber}]`;
	    }

	    return result;
	  }),
	};
      });

      return chips;
    }, {});

    return slots.concat(board);
  }, []);

  if (false) {
    gatherNetByName(backplane);
    defineBackplanePins(backplane);
    if (needCheck) checkNetConnectivity(backplane.netByName);
    if (options.dumpSignals) dumpSignals(bp);
  }

  fs.writeFileSync('bp.dump', util.inspect(bp, {depth: 99}));

  return bp;
}


module.exports.compile = compile;
