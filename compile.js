#!/usr/bin/env node
'use strict';

const util = require('util');
const fs = require('fs');
const assert = require('assert');

const CMDR = require('commander').program;
const PEG = require('pegjs');

const CRAM = require('./tools/write-cram-mem');
const DRAM = require('./tools/write-dram-mem');

const logic = require('./logic.js');


// Provided by caller of `compile()`.
var options;


function parseFile(parser, filename) {
  let fileAST;

  try {
    // Pass "options" so we can call our `astDirToDir()` function from parser.
    fileAST = parser.parse(fs.readFileSync(filename, 'utf8'), {astDirToDir});
  } catch (e) {
    console.log(`ERROR: Parsing Failure: ${e.message}`);

    if (e.location) {
      console.log(`\
       start: ${e.location.start}
         end: ${e.location.end}`);
    } else {
      console.log(`Exception: ${dumpThing(e)}`);
    }

    process.exit(1);
  }

  return fileAST;
}


function parseBackplanes(parser) {
  const filename = options.src;
  const bp = parseFile(parser, filename)[0];

  if (options.dumpAst) fs.writeFileSync(`${bp.name}.before.evaluation`, dumpThing(bp));

  bp.boards = {};

  // For each slot for which we haven't already parsed the board netlist,
  // parse it and save it in `bp.boards` indexed by module ID (e.g., 'edp').
  // While we're at it, accumulate the board's list of net names and what
  // is connected, remembering direction and PDF reference for each such.
  bp.slots
    .filter(slot => slot.module && slot.module.id != 'ignore' && !bp.boards[slot.module.id])
    .forEach(slot => {
      const id = slot.module.id;
      const boardPath = `board/${id}.board`;

      console.log(`[parse ${boardPath}]`);
      const board = parseFile(parser, boardPath);
      bp.boards[id] = board;

      if (board.bpPins && options.dumpPins) {
	fs.writeFileSync(`${id}.bp-pins`,
			 Object.keys(board.bpPins)
			 .sort()
			 .map(bpp => Object.values(board.bpPins[bpp])
			      .map(p => {
				const pdfRef = p.page.pdfRef.padEnd(7);
				const chipPin = `${p.chip.name}.${p.pin}`.padEnd(9);
				return `\
${bpp}  ${p.dir}  ${chipPin} ${pdfRef} ${p.net}`;
			      })
			      .join('\n')
			     )
			 .join('\n') + '\n');
      }
    });

  return bp;
}


////////////////////////////////////////////////////////////////////////////////
function bindSlots(bp, cramDefs) {
  // Build bpMacroEnv which is the basis of macros used for each board.
  const bpMacroEnv = {};
  (bp.macros || []).forEach(macro => bpMacroEnv[macro.id] = macro.value);

  bp.cramDefs = cramDefs;
  bp.vNetToPins = {};

  console.log(`Backplane ${bp.name}:`);

  // For each slot, expand the board's macros for the slot (and
  // backplane, and CPU type) specifics.
  bp.slots
    .filter(slot => slot.module && slot.module.id != 'ignore')
    .forEach(slot => {
      const slotNumber = slot.n.padStart(2, '0');
      const slotName = slotNumber;
      const id = slot.module.id;
      const board = bp.boards[id];
      const macros = slot.module.macros || [];
      const macroDesc = macros.map(macro => `${macro.id}=${macro.value}`).join (' ');

      console.log(`  Slot ${slotName}: ${id.padEnd(4)} ${macroDesc.padEnd(12)} ${slot.module.comments}`);

      // Each board macro env starts with copy of BP macro vars as
      // base, then we add this board's values, possibly overriding
      // existing ones.
      const macroEnv = {...bpMacroEnv};
      macros.forEach(macro => macroEnv[macro.id] = macro.value);

      // Remember this slot's macros so we can generate Verilog `defines for them.
      slot.macroEnv = macroEnv;

      // Create a slot-unique copy of each board's chips and interconnecting nets.
      slot.chips = {};
      slot.verilogRefNum = 0;

      // Bind backplane pins to their nets.
      Object.keys(board.bpPins).forEach(bpp => {
	const pinNets = board.bpPins[bpp];

	const gNets = Object.values(pinNets).
	      map(pinNet => pinNet.netAST ?
		  canonicalize(pinNet.netAST.map(e => evalExpr(e, macroEnv, true)).join('')) :
		  pinNet.net);

	const dirs = Object.values(pinNets)
	      .map(pinNet => pinNet.dir)
	      .sort().
	      join('');

	if (!gNets.every(e => e === gNets[0])) {
	  console.error(`
ERROR: Not all nets on ${id}.${bpp} are the same net:
  ${gNets.join('\n  ')}
`);
	}

	// For pins driven by CRAM modules, define global net name from
	// CRAM definitions, in preference to the definition on the module.
	// E.g., `crm.be2[cpu.44]`
	const cramPinName = `${id}.${bpp}[${id}.${slotNumber}]`;
	const cd = cramDefs.bp[cramPinName];
	const gNet = cd ? cd.net : gNets[0];
	const vNet = verilogify(gNet);
	slot.bpPins[bpp] = { gNet, vNet, pinNets, dirs, bpp, };
	addSlotVNet(bp, slot.bpPins[bpp], slotNumber, `${slotNumber}.${id}`);
      });

      if (options.dumpSlots) {
	fs.writeFileSync(`${slotNumber}.${id}.slot`,
			 Object.keys(slot.bpPins)
			 .sort()
			 .map(bpp => {
			   const v = slot.bpPins[bpp];
			   return `\
${slotNumber}.${bpp}[${v.dirs}]: ${v.vNet}`;
			 })
			 .join('\n') + '\n');
      }

      board.pages
	.flatMap(page => page.chips) // Collect all the chips on all the pages
	.forEach(chip => {

	  // Insert hand-coded verilog if present as if it were a "chip".
	  if (chip.nodeType === 'Verilog') {
	    slot.verilogRefNum = slot.verilogRefNum + 1;
	    chip.name = `verilog${slot.verilogRefNum}`;

	    slot.chips[chip.name] = {
	      type: 'verilog',
	      desc: '',
	      refDes: chip.name,
	      verilog: chip.v,
	      pins: [],
	    };
	  } else {

	    slot.chips[chip.name] = {
	      type: chip.type,
	      desc: chip.desc,
	      refDes: chip.name,

	      pins: chip.pins.reduce((cur, pin) => {
		let net = null;

		if (pin.bpPin) {
		  const cramPinName = `${id}.${pin.bpPin}[${id}.${slotNumber}]`;
		  const cd = cramDefs.bp[cramPinName];

		  if (cd) net = verilogify(cd.net);
		}

		if (!net) net = verilogify(canonicalize(evalExpr(pin.net, macroEnv, true)));

		const pinName = logic.pinToName(chip.type, pin.pin, pin.dir);

		if (!pinName) {
		  console.error(`ERROR: ${chip.name}: ${chip.type} pin ${pin.pin} is not ${pin.dir}`);
		}

		cur[pinName] =  {
		  dir: astDirToDir(pin.dir),
		  net,
		  name: chip.name,
		};

		return cur;
	      }, {}),
	    }
	  };
	});
    });

  if (options.dumpPins) {
    fs.writeFileSync(`bp.wires`,
		     Object.keys(bp.vNetToPins)
		     .filter(vn => vn != '%NC%')
		     .sort()
		     .map(vn => {
		       const pins = bp.vNetToPins[vn];
		       return `\
${vn.padStart(40)}: ${Object.keys(pins).join(' ')}`;
		     })
		     .join('\n') + '\n');
  }
  
  if (options.dumpUndriven) {
    fs.writeFileSync(`${bp.name}.undriven`,
		     Object.keys(bp.vNetToPins)
		     .filter(vn => vn != '%NC%')
		     .sort()
		     .filter(vn => !Object.keys(bp.vNetToPins[vn])
			     .some(e => e.match(/D[0-9]/)))
		     .map(vn => {
		       const pins = bp.vNetToPins[vn];
		       return `\
${vn.padStart(40)}: ${Object.keys(pins).join(' ')}`;
		     })
		     .join('\n') + '\n');

  }

  if (options.dumpAst) fs.writeFileSync(`${bp.name}.after.evaluation`, dumpThing(bp));
  return bp;
}


function addSlotVNet(bp, sv, slotNumber, vnv) {
  if (!bp.vNetToPins[sv.vNet]) bp.vNetToPins[sv.vNet] = {};
  const d = sv.dirs.includes('D') ? 'D' : 'i';
  bp.vNetToPins[sv.vNet][`${d}${slotNumber}.${sv.bpp}`] = vnv;
}


////////////////////////////////////////////////////////////////////////////////
// Complain if nets are not driven and not on the backplane connector
// or if driven by more than one pin.
function checkNetConnectivity(netByName) {

  console.log(`Check nets for proper connectivity:`);

  Object.keys(netByName).forEach(netName => {
    if (netName === '%NC%') return;
    if (netName == 0) return;
    if (netName == 1) return;

    const pins = netByName[netName];

    if (pins.length === 0) {
      console.log(`WARNING NOT CONNECTED: "${netName}" is not connected`);
    } else {
      const driving = pins.filter(pin => pin.dir === '~>');

      if (driving.length > 1) {

        if (options.dumpWireOr) {
          console.log(`WARNING WIRE-OR: "${netName}" is wire-OR driven by ${driving.length} pins:`);
          if (options.verboseErrors) console.log(`    ${util.inspect(driving)}`);
        }
      } else if (driving.length === 0 && !pins.some(pin => pin.bpPin)) {

        if (options.dumpUndriven) {
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

  case 'Stub':
    console.log(`= = = STUB`);
    cx.board = ast;
    break;

  case 'Pin':
    cx.pin = ast;
    cx.pin.chip = cx.chip;
    cx.pin.fullName = cx.pin.chip.page.name + '.' + cx.pin.chip.name + '.' + cx.pin.pin;
    cx.pin.symbol = Symbol(cx.pin.fullName);
    cx.net = '';

    switch (cx.pin.net.nodeType) {
    case 'Macro':
      cx.net += evalExpr(cx.pin.net, macroEnv, true);	// Handles selectors and simple macros
      break;

    case 'Selector':
      const selected = evalExpr(cx.pin.net.head, macroEnv, true);
      cx.net += evalExpr(cx.pin.net.list[+selected - 1], macroEnv, false);
      break;

    case 'IDList':
      cx.net = cx.pin.net.list.map(id => evalExpr(id, macroEnv, false)).join('');
      break;

    case 'IDChunk':
      cx.net += cx.pin.net.name;
      break;

    case 'VerilogChunk':
      cx.net += cx.pin.net.name.slice(1);
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

    cx.pin.netName = cx.net.trim();
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
function evalExpr(t, macroEnv, macrosAllowed) {
  let result;

  if (!t || !t.nodeType) debugger;

  switch (t.nodeType) {
  case 'Macro':
    result = evalExpr(t.head, macroEnv, true);
    break;

  case 'Selector':
    result = evalExpr(t.head, macroEnv, true);
    const selected = t.list[+result - 1]; // 1-origin indexing

    if (result < 1 || selected === null) {
      console.log(`ERROR: Selector produces undefined result=${result} selected=${selected}:
${util.inspect(t, {depth:99})}`);
      result = '%NC%';
    } else {

      // Note that the selected value may contain a macro to be
      // expanded, but only within its own set of []s. It is only
      // the `t.head` inside these []s that should be expanded.
      result = evalExpr(selected, macroEnv, false);
    }

    break;

  case '+':
  case '-':
  case '/':
  case '*':
    // This is complicated by the need to keep the values as strings
    // and to evaluate results to preserve the number of digits, which
    // is the max of the length of each of the operands.
    const L = evalExpr(t.l, macroEnv, macrosAllowed);
    const R = evalExpr(t.r, macroEnv, macrosAllowed);
    const resultStr = Math.trunc(eval(`${parseInt(L, 10)} ${t.nodeType} ${parseInt(R, 10)}`));
    const digits = (t.nodeType === '-' || t.nodeType === '+') ? Math.max(L.length, R.length) : 0;
    result = padValueToDigits(resultStr, digits)
    break;

  case 'IDList':
    result = t.list.map(id => evalExpr(id, macroEnv, macrosAllowed)).join('');
    break;

  case 'IDChunk':
    result = macrosAllowed ? macroEnv[t.name] : t.name;
    if (result === undefined) result = t.name;
    break;

  case 'VerilogChunk':
    result = t.name;
    break;

  case 'Value':
    result = t.value;
    break;

  case 'NoConnect':
    result = '%NC%';
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


function compile(simOptions) {
  options = simOptions;

  // libreoffice --convert-to csv ./cram-backplane.ods
  const cramDefs = readCRAMBackplane('cram-backplane.csv');

  if (options.dumpCram) {
    fs.writeFileSync('bp.cram-defs',
		     util.inspect(cramDefs, {
		       depth: 99,
		       breakLength: 90,
		       maxArrayLength: Infinity,
		     }));
  }

  const parser = PEG.generate(fs.readFileSync('netlist.pegjs', 'utf8'), {
    output: 'parser',
    trace: options.traceParse,
  });

  // Parse the backplane definition and collapse the board page
  // substructure into a list of chips on the board.
  const bp = parseBackplanes(parser);

  // Bind each board into the slot(s) it fits into, assigning
  // macro-expanded net names and pins.
  bindSlots(bp, cramDefs);

  if (options.dumpBackplane) fs.writeFileSync('bp.dump', dumpThing(bp));

  if (options.dumpPins) dumpPins(bp);
  if (options.dumpVerilog) dumpVerilogNames(bp);
  if (options.dumpNets) dumpNets(bp);

  if (options.genSV) genSV(bp);

  if (options.genCram) genCram(bp);
  if (options.genDram) genDram(bp);

  if (options.dumpBadAnonymous) checkAnonymousNames(bp);
  if (options.dumpMalformed) checkForMalformedSymbolNames(bp);
  
  return bp;
}


function vDirForNets(nets) {
  return nets.some(net => net.dir === 'D') ? 'output' : 'input';
}


function modNameForSlot(slot) {
  const id = slot.module.id;
  const slotNumber = slot.n.padStart(2, '0');
  return id + slotNumber;
}


function genSV(bp) {
  genBackplaneSV(bp);

  // Accumulator indexed by vNet name of list of backplane pins
  // attached to the signal.

  bp.slots
    .filter(s => s.module.id !== 'ignore')
    .forEach(slot => {
      const modName = modNameForSlot(slot);

      // Build modPins list.
      const modPins = Object.keys(slot.bpPins)
	.filter(bpp => slot.bpPins[bpp].gNet !== '%NC%')
	.sort((a, b) => {
	  const aSym = slot.bpPins[a].vNet;
	  const bSym = slot.bpPins[b].vNet;
	  return aSym < bSym ? -1 : aSym > bSym ? +1 : 0;
	})
	.reduce((cur, bpPin) => {
	  const p = slot.bpPins[bpPin];
	  const dir = p.dirs[0] === 'D' ? 'output' : 'input';
	  cur[bpPin] = {vNet: p.vNet, bpPin, dir};
	  return cur;
	}, {});

      const modParams = Object.values(Object.values(modPins)
				      // Remove duplicates
				      .reduce((cur, v) => {cur[v.vNet] = v; return cur}, {}))
	    .map(v => `\
    ${v.dir.padEnd(6)} ${v.vNet}`)
	    .join(',\n  ');

      const macros = genSlotMacros(bp, slot, modName);
      const modV = bp.boards[slot.module.id].verilog;
      const nets = genSlotNets(bp, slot, modName);
      const chips = genSlotChips(bp, slot, modName);

      fs.writeFileSync(`./rtl/gen/${modName}.sv`, `\
\`include "kl10pv.svh"

module ${modName} ${macros} (
  ${modParams}
  ${(modV || '').trimEnd()}
);

  ${nets}

  ${chips}
endmodule	// ${modName}
`);
    });

  function vSort(a, b) {
    return a[0].vNet > b[0].vNet ? +1 : a[0].vNet < b[0].vNet ? -1 : 0;
  }
}


function genSlotMacros(bp, slot, modName) {
  if (Object.keys(slot.macroEnv).length == 0) return ``;
  return `#(
    parameter ${Object.keys(slot.macroEnv)
    .map(mac => `${mac} = ${slot.macroEnv[mac]}`)
    .join(',\n    ')})
`;
}


function genBackplaneSV(bp) {
  // Define each net in the backplane.
  const decls = Object.keys(bp.vNetToPins)
	.filter(n => n !== '%NC%' && n !== 'clk60')
	.sort()
	.map(n => `  bit ${untickify(n)};`)
	.join('\n');

  fs.writeFileSync(`./rtl/gen/kl-backplane.svh`, `
${decls}
`);
}


// Emit the board instances to represent the chips on the board in a slot.
function genSlotChips(bp, slot, modName) {

  const allChips = Object.values(slot.chips)
	.sort((a, b) => a.name > b.name ? +1 : a.name < b.name ? -1 : 0)
	.map(chip => {

	  if (chip.type === 'verilog') {
	    return `
// Inline verilog
${chip.verilog}\
// End inline verilog
`;
	  } else {
	    return `\
    ${chipTypeToModName(chip)} ${chip.refDes}(
      ${genChipPins(bp, slot, chip)});
`;
	  }
	}).join('\n');

  return `
// Chips in ${modName} instance
${allChips}
`;
}


// Emit the wiring between chips within a slot.
function genSlotNets(bp, slot, modName) {
  const wires = {};		// Indexed by verilogified signal name

  Object.values(slot.chips)
    .forEach(chip => {

      // Gather in `wires[vNet]` a list of attached pins.
      Object.values(chip.pins || {})
      // Filter out constant value nets.
        .filter(pin => pin.net != 0 && pin.net != 1 && pin.net !== '%NC%')
      // Filter out backplane signals by vNet name since they will
      // be declared for module input/output.
        .filter(pin => {
	  const v = !Object.values(slot.bpPins)
		.some(bpp => bpp.vNet === pin.net);
	  return v;
	})
	.filter(pin => pin.net != '1' && pin.net != '0')
	.forEach(pin => wires[pin.net] = (wires[pin.net] || []).concat(pin));
    });

  // Walk through the nets in this slot and find multiple drivers of,
  // e.g., `funky signal h`.  Change drivers to drive new signals
  // `funky signal h$1`, `funky signal h$2`, etc.  (We use the index
  // in `wires[]` + 1 as the uniquifier integer for the signal name.)
  // OR these together producing `funky signal h`.  Inputs continue to use
  // `funky signal h`, which is bound to the output of the OR.
  const bitDecls = Object.keys(wires)
	.sort()
	.map(w => {
	  const driving = wires[w].filter(v => v.dir === 'D');

	  if (driving.length > 1) { // Has two or more wire-ORed drivers

	    // Generate the list of new signal names, while replacing
	    // driving pin target wire names with the new ones.  Must
	    // use wires[] and not driving[] because we are changing
	    // wires at specified index in wires[].
	    const drivers = wires[w].flatMap((pin, pinX) => {

	      if (pin.dir === 'D') {
		const newName = w + '$' + (pinX+1);
		wires[w][pinX].net = newName;
		return newName;
	      } else {
		return [];
	      }
	    });

	    return `\
bit ${drivers.join(', ')};
  bit ${w};
  always_comb ${w} = ${drivers.join(' | ')};`
	  } else if (!isTicked(w)) { // Just pass raw verilog expressions or names through
	    return `bit ${w};`
	  }
	})
	.join('\n  ');

  return `\
  // Wires and wire-ORs in ${modName} instance
  ${bitDecls}
`;
}


function isTicked(s) {
  if (!s || !s.slice) return false;
  return s.slice(0, 1) === '`';
}


function untickify(s) {
  return isTicked(s) ? s.slice(1) : s;
}


function genChipPins(bp, slot, chip) {

  return Object.keys(chip.pins)
    .map(pinName => {
      const pin = chip.pins[pinName];
      let value = pin.net;

      if (value === '0') value = `0`;
      else if (value === '%NC%') value = pin.dir === 'I' ? `0` : ``;
      else if (value == 1) value = `1`;

      return `.${verilogify(pinName)}(${untickify(value)})`;
    })
    .join(',\n      ');
}  


// For chip types that start with numbers, assume they are mcXXX.
// Substitute "_" for "-" in chip types to make valid identifiers.
function chipTypeToModName(chip) {
  let n = chip.type.replace(/-/g, '_');
  if (n === 'wire') n = 'just_a_wire';
  return chip.type.match(/^[0-9].*/) ? `mc${n}` : n;
}


function genCram(bp) {
  const fn = options.genCram;
  console.log(`[generate ${fn}]`);
  fs.writeFileSync(fn, `\
${CRAM.write()}
`);
}


function genDram(bp) {
  const fn = options.genDram;
  console.log(`[generate ${fn}]`);
  fs.writeFileSync(fn, `\
${DRAM.write()}
`);
}


function readCRAMBackplane(fn) {
  return fs.readFileSync(fn, 'utf8')
    .split('\n')
    .filter((line, x) => line && x != 0)
    .reduce((cram, line) => {
      const [netUC, offsetExpr, nExpr, bitExpr, pinFull, ucBitExpr] = line.split(',');
      const net = netUC.toLowerCase();
      const bit = +bitExpr;
      const ucBit = +ucBitExpr;
      const slot = pinFull.slice(2, 4);
      const bpPinName = `${pinFull[1]}${pinFull.slice(4)}`.toLowerCase();
      const srcPin = `crm.${bpPinName}[crm.${slot}]`;

      if (isNaN(slot)) console.error(`${fn} bad slot number in line '${line}'`);

      const pPin = cram.bp[srcPin];

      if (pPin) {
	console.log(`srcPin="${srcPin}" pPin=${util.inspect(pPin)}`);
	const pb = pPin.bit.toString();
	const pn = pPin.net;
	console.error(`${fn} duplicate '${net}' srcPin '${srcPin}', was ${pb.padStart(3)} '${pn}'`);
      }

      if (cram.nets[net]) console.error(`${fn} defines net '${net}' more than once`);
      cram.bp[srcPin] = {net, srcPin, bpp: bpPinName, slot, bit};
      if (!cram.slot[slot]) cram.slot[slot] = {};
      cram.slot[slot][srcPin] = cram.bp[srcPin];
      cram.nets[net] = cram.bp[srcPin];
      return cram;
    }, {nets: {}, slot: {}, bp: {}, });
}


function astDirToDir(d) {
  return (d === '~<') ? 'I' : (d === '~>') ? 'D' : `???${d}`;
}


// Convert DEC nomenclature name `n` to Verilog identifier.
// Use the following mappings and rules:
//  * ` ` ==> _
//  * `<-` ==> GETS
//  * <digits>-<digits> ==> <digits>to<digits>
//  * i/o ==> IO
//  * xxx<digit>-e<digits>-<digits> ==> xxx<digits>_e<digits>_<digits>
//  * [/,*.-+=#()%^<>&] ==> SYMBOLNAME
//  * `-xxxx h` ==> `xxxx l`
//  * `-xxxx l` ==> `xxxx h`
const charSymNames = {
  '-': 'NG',
  '/': 'SL',
  ',': 'CM',
  '*': 'ST',
  '.': 'DT',
  '+': 'PL',
  '=': 'EQ',
  '#': 'NR',
  '(': 'LP',
  ')': 'RP',
  '%': 'PE',
  '^': 'CT',
  '<': 'LT',
  '>': 'GT',
  '&': 'AN',
  '[': 'LB',
  ']': 'RB',
};

function verilogify(n) {
  if (isTicked(n)) return n;

  // First convert -xxxx [lh] to xxxx [hl].
  n = canonicalize(n);

  if (n === '%NC%' || n == 1 || n == 0) return n;
  n = n.replace(/ /g, '_');
  n = n.replace(/<-/g, 'GETS');
  n = n.replace(/([a-z][a-z][a-z0-9][0-9]*)-([a-z]+\d+)-(\d+)/g, '$1_$2_$3');
  n = n.replace(/(\d+)-(\d+)/g, '$1to$2');
  n = n.replace(/i\/o/g, 'IO');
  n = n.replace(/10\/11/g, '10_11');
  n = n.split('').map(ch => charSymNames[ch] || ch).join('');
  return n;
}


function checkForMalformedSymbolNames(bp) {
  const malformed = Object.entries(bp.boards)
	.map(([boardID, board]) => Object.keys(board.nets)
	     // Remove valid no connect symbol
	     .filter(n => n != '%NC%' && n != '0' && n != '1')
	     // Remove valid xxx [hl]
	     .filter(n => !n.slice(-2).match(/ [hl]/))
	     // Remove valid xxx hi for local logic 1 symbol used on some boards
	     .filter(n => n.slice(-3) != ' hi' && n != 'hi')
	     // Remove valid local anonymous net names mod-e99-99
	     .filter(n => !n.match(/([a-z][a-z][a-z0-9][0-9]*)-([a-z]+\d+)-(\d+)/))
	     .map(n => `${boardID}: '${n}'`)
	     .join('\n'));

  if (malformed) {
    console.error(`\

MALFORMED symbol names:\n
${malformed.join('\n')}

`);
  } else {
    console.log(`[no malformed symbol names found]`);
  }
}


function checkAnonymousNames(bp) {
  Object.entries(bp.boards)
    .forEach(([boardID, board]) => Object.entries(board.nets)
	     .forEach(([n, boardNet]) => {
	       const m = n.match(`(?<id>[a-z]+[0-9]?)[0-9]-(?<chip>[a-z][0-9]+)-(?<pin>[0-9]+)`);
	       if (!m) return;

	       const {id, chip, pin} = m.groups;

	       if (!boardNet.some(bn => bn.dir === 'D')) {
		 console.error(`${boardID}: ${chip}.${pin} ${n} not driven`);
	       }

	       boardNet.forEach(bn => {

		 if (id !== boardID) {
		   console.error(`${boardID}: ${n}: '${id}' mismatches board ID '${boardID}'`);
		 }

		 if (bn.dir === 'D') { // Driving nets should match the chip/pin they attach to

		   // Unless they are part of a wired-OR
		   if (boardNet.some(wbn => wbn !== bn && wbn.dir === 'D')) return;

		   if (bn.chip.name !== chip) {
		     console.error(`${boardID}: ${n} chip '${chip}' mismatches '${bn.chip.name}'`);
		   }

		   if (bn.pin !== pin) {
		     console.error(`\
${boardID}: ${n} pin '${pin}' mismatches driving pin '${bn.chip.name}.${bn.pin}'`);
		   }
		 } else {	// Find matching driving pin for this input pin
		 }
	       });
	     }));
}


function dumpVerilogNames(bp) {
  fs.writeFileSync('bp.verilog-names',
		   Object.keys(bp.n2v)
		   .sort(netNameSort)
		   .map(nName => `${nName.padStart(50)}: ${bp.n2v[nName]}`).join("\n") + "\n")
}


function dumpPins(bp) {
  if (false) {
  fs.writeFileSync('bp.pins',
		   Object.keys(bp.allPins)
		   .sort(slotPinSort)
		   .map(bpPin => `\
${bpPin}:
  ${Object.values(bp.allPins[bpPin])
    .map(pin => util.inspect(pin) /*`${pin.dir} ${pin.lNet.padEnd(35)}${pin.fullName}`*/)
    .join("\n  ")}`)
		   .join("\n") + "\n");
  }
  
  function slotPinSort(a, b) {
    return a > b ? 1 : a < b ? -1 : 0;
  }
}


function dumpNets(bp) {
  fs.writeFileSync('bp.nets',
		   Object.keys(bp.allNets)
		   .filter(k => k != '%NC%')
		   .sort(netNameSort)
		   .sort(netNameSort)
		   .map(netName => `\
${netName}:
  ${Object.keys(bp.allNets[netName])
    .map(pinFullName => {
      const pin = bp.allPins[pinFullName];
      if (!pin) console.error(`pin==null for ${pinFullName}`);
      return `${pin.dir} ${pinFullName.padEnd(20) + (pin.bpPin || '').padEnd(20)}${pin.pdfRef}`;
    })
		   .join("\n  ")}`)
		   .join("\n") + "\n");

  // Sort e.g., "edp.aa1[38]" so the slot number
  // "38" is primary, module "edp" is next,
  // pin "aa1" is last.
  function slotPinSort(a, b) {
    a = bp.allPins[a];
    b = bp.allPins[b];
    const [aModule, aPin, aSlot] = [a.module, a.pin, a.slotName];
    const [bModule, bPin, bSlot] = [b.module, b.pin, b.slotName];

    return aSlot > bSlot ? 1 : aSlot < bSlot ? -1 :
      aModule > bModule ? 1 : aModule < aModule ? -1 :
      aPin > bPin ? 1 : aPin < bPin ? -1 : 0;
  }
}


function netNameSort(a, b) {
  a = a.replace(/^[^a-zA-Z]/g, '');
  b = b.replace(/^[^a-zA-Z]/g, '');
  return a > b ? 1 : a < b ? -1 : 0;
}


// Convert a net name of the form '-xyz l' to 'xyz h' or '-xyz h' to 'xyz l'.
function canonicalize(net) {

  // Some nets aren't strings, so only do this if they are.
  if (net.slice && net.slice(0, 1) === '-') {
    const lastChars = net.slice(-2);

    if (lastChars === ' h') {		// Switch to 'l'
      return `${net.slice(1, -2)} l`;
    } else if (lastChars === ' l') {	// Switch to 'h'
      return `${net.slice(1, -2)} h`;
    }
  }

  // If not negated net name just return as-is.
  return net;
}


// Do standardized util.inspect() on `thing`. See `without()`.
function dumpThing(thing, dumpWithout) {
  return util.inspect(without(thing, dumpWithout), {depth: 9, maxArrayLength: Infinity});
}


// If `toDrop` is not null it is a string name of a key to not dump or
// it is an object whose keys list things not to dump or it is an
// array whose elements are strings to not dump.
function without(thing, toDrop) {
  if (!toDrop) toDrop = {};
  if (typeof toDrop === 'string') toDrop = {[toDrop]: toDrop};
  if (Array.isArray(toDrop)) toDrop = toDrop.reduce((cur, e) => ({ [e]: e, ...cur}), {});

  // Now `toDrop` is in canonical form: an object whose keys are the
  // list of keys not to dump. Remove those keys from a copy of
  // `thing`.
  const cleanThing = {...thing};
  Object.keys(toDrop).forEach(k => delete cleanThing[k]);
  return cleanThing;
}


function testDumpThing() {
  const o = {a: 1, b: 2, c: 3};
  const oo = {...o};
  test1(o, 'b', '{ a: 1, c: 3 }');
  if (!shallowEQ(oo, o)) console.error(`Unit test FAIL: dumpThing removed element from original object`);

  test1(o, {b:'bbb'},			'{ a: 1, c: 3 }');
  test1(o, {b:'bbb', a: 'aaa'},		'{ c: 3 }');
  test1(o, {c:'ccc'},			'{ a: 1, b: 2 }');
  test1(o, {c:'ccc', b:'bbb', a:'aaa'}, '{}');
  test1(o, {a:'aaa'},			'{ b: 2, c: 3 }');

  test1(o, ['b'], '{ a: 1, c: 3 }');
  test1(o, ['b', 'a'], '{ c: 3 }');
  test1(o, ['c', 'a'], '{ b: 2 }');
  test1(o, ['c', 'a', 'b'], '{}');

  function test1(o, without, sb) {
    const s = dumpThing(o, without);
    if (s != sb) console.error(`Unit test FAIL: dumpThing was '${s}' and should be '${sb}'`);
  }


  function shallowEQ(x, y) {
    return [...Object.keys(x), ...Object.keys(y)].every(k => x[k] === y[k]);
  }
}


function testCanonicalize() {
  test1('-ctl2 ar 00-11 clr h', 'ctl2 ar 00-11 clr l');
  test1('ctl2 ar 00-11 clr h', 'ctl2 ar 00-11 clr h');
  test1('ctl2 ar 00-11 clr l', 'ctl2 ar 00-11 clr l');
  test1('-ctl2 ar 00-11 clr FOO', '-ctl2 ar 00-11 clr FOO');
  test1('-ctl2 ar 00-11 clr l', 'ctl2 ar 00-11 clr h');

  function test1(a, sb) {

    if (canonicalize(a) != sb) {
      console.error(`Unit test FAIL: canonicalize('${a}') != '${sb}' is '${canonicalize(a)}'`);
    }
  }
}


function padValueToDigits(v, digits) {

  if (v < 0) {
    return '-' + String(-v).padStart(digits, '0');
  } else {
    return String(v).padStart(digits, '0');
  }
}

function testPadValueToDigits() {
  test1(123, 4, '0123');
  test1(123, 5, '00123');
  test1(123, 3, '123');
  test1(-123, 4, '-0123');
  test1(-123, 5, '-00123');
  test1(-123, 3, '-123');
  test1(0, 4, '0000');
  test1(0, 1, '0');

  function test1(v, d, sb) {

    if (padValueToDigits(v, d) !== sb) {
      console.error(`Unit test FAIL: padValueToDigits(${v}, ${digits}) != '${sb}' is '${padValueToDigits(v, d)}'`);
    }
  }
}


function testMacrosAndSelectors() {
  const parser = PEG.generate(fs.readFileSync('netlist.pegjs', 'utf8'), {
    output: 'parser',
  })

  const env = {a: '1', b: '2', c: '3', d: '4', e: '99', f: '999', n: '0'};
  const t1src = `\
Page: T1, PDF1

t1: 10101 quad or/nor
    4 ~< {ep1} [a,scd2 sc 36 to 63 h,%NC%]
    2 ~> {aa1} a[a,a,aa,aaa,aaaa]a
    5 ~> {ab1} [a,xa,xb,xc,xd]
    7 ~< {ac1} test[b,xa,xb,xc,xd]
    3 ~> {ad1} pin3[c,xa,xb,xc,xd]pin3
    9 ~> {ae1} [d,xa,xb,xc,xd] pin9
    13 ~< {af1} pin13 [e] pin13
    15 ~> {ba1} pin15 [a+b+c/3,xa,xb,xc,xd]
    6 ~> {ak1} [a,adx cry [n+06] h,ctl adx cry 36 h]
    14 ~> {ak1} [b,adx cry [n+06] h,ctl adx cry 36 h]
`;

  const t1 = parser.parse(t1src, {astDirToDir});
//  console.log(`testMacrosAndSelectors: ${dumpThing(t1)}`);
  const t1nets = {};
  expandMacros(t1, t1nets, env);

  const pins = t1.pages[0].chips[0].pins;
//  console.log(`testMacrosAndSelectors: ${pins.map(p => `${p.pin}:${p.netName}`).join('\n')}`);

  const netNameSB = {
    4: 'scd2 sc 36 to 63 h',
    2: 'aaa',
    5: 'xa',
    7: 'testxb',
    3: 'pin3xcpin3',
    9: 'xd pin9',
    13: 'pin13 99 pin13',
    15: 'pin15 xd',
    6: 'adx cry 06 h',
    14: 'ctl adx cry 36 h',
  };

  pins.map(p => {

    if (p.netName != netNameSB[+p.pin]) {
      console.error(`${p.pin}:  was '${p.netName}'  sb '${netNameSB[+p.pin]}'`);
      console.error(`text='${p.net.text}':
${dumpThing(p.net)}
`);
    }
  });
}


function doTests() {
  console.log(`[starting unit tests]`);
  testMacrosAndSelectors();
  testDumpThing();
  testCanonicalize();
  testPadValueToDigits();
  console.log(`[done]`);
}

CMDR
  .showHelpAfterError()
  .option('-a, --dump-ast', `Dump AST after parsing`)
  .option('-b, --dump-backplane', `Dump backplane slots and net names`)
  .option('-c, --dump-cram', `Dump CRAM definitions`)
  .option('-A, --dump-bad-anonymous', `Dump anonymous net names that don't follow the rules properly`, true)
  .option('-M, --dump-malformed', `Dump malformed signal names`)
  .option('-C, --gen-cram <cramPath>', `Generate CRAM .mem file to specified path name`)
  .option('-D, --gen-dram <dramPath>', `Generate DRAM .mem file to specified path name`)
  .option('-g, --genSV', `Generate SystemVerilog code for backplane and modules`)
  .option('-p, --dump-pins', `Dump board pins and backplane pins for each board`)
  .option('-s, --dump-slots', `Dump slot signals after parsing`)
  .option('-t, --trace-parse', `Print trace while parsing netlist`)
  .option('-u, --dump-undriven', `Dump list of undriven nets`)
  .option('-v, --verbose-errors', `Give more info for errors`)
  .option('-V, --dump-verilog', `Dump Verilogified symbols`)
  .option('-w, --dump-wires', `Dump list of wires on each board`)
  .option('-T, --run-tests', `Run built-in unit tests`)
  .argument('[src]', `Source file to start parsing`, `kl10pv.backplane`)
  .action((src, options) => {
    options.src = src;
    if (options.runTests) doTests();
    const backplanes = compile(options);
    console.log(`[done]`);
  })
  .parse();
