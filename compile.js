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


function parseBackplanes(parser) {
  const filename = options.src;
  const bpAST = parseFile(parser, filename)[0];

  if (options.dumpAst) fs.writeFileSync(`${bpAST.name}.before.evaluation`, util.inspect(bpAST, {depth: 9999}));
  console.log(`Backplane ${bpAST.name}:`);

  const bpMacros = bpAST.macros || [];
  const bpMacroDesc = bpMacros.map(macro => `${macro.id}=${macro.value}`).join (' ');
  const bpMacroEnv = {};

  bpMacros.forEach(macro => bpMacroEnv[macro.id] = macro.value);

  // For each slot, (re)parse the board definition and expand its
  // macros for the slot (and backplane, and CPU type) specifics.  The
  // re-parsing makes each board's data structures a unique deep copy.
  bpAST.slots
    .filter(slot => slot.board && slot.board.id != 'ignore')
    .forEach(slot => {
      const slotNumber = slot.n;
      const slotName = `${bpAST.name}.${slotNumber.padStart(2, '0')}`;
      const board = slot.board;
      const macros = board.macros || [];
      const macroDesc = macros.map(macro => `${macro.id}=${macro.value}`).join (' ');

      // Each board macro env starts with copy of BP macro vars as
      // base, then we add this board's values, possibly superseding
      // exiting ones.
      const macroEnv = {...bpMacroEnv};
      macros.forEach(macro => macroEnv[macro.id] = macro.value);

      console.log(`  Slot ${slotName}: ${board.id.padEnd(4)} ${macroDesc.padEnd(12)} ${board.comments}`);

      const boardAST = parseFile(parser, `board/${board.id}.board`);
      expandMacros(boardAST, bpAST, macroEnv);
      slot.board = {slotName, ... board, ... boardAST};
    });

  if (options.dumpAst) fs.writeFileSync(`${bpAST.name}.after.evaluation`, util.inspect(bpAST, {depth: 9999}));
  return bpAST;
}


////////////////////////////////////////////////////////////////////////////////
// Define connections between pins and nets, including those on backplane.
function definePinsAndNets(bp, cramDefs) {
  bp.allNets = {};
  bp.allPins = {};

  bp.slots.forEach(board => {

    Object.values(board.chips).forEach(chip => {

      chip.pins.forEach(pin => {

	const newNet = {
	  pin: pin.pin,
	  dir: pin.dir,
	  fullName: pin.fullName,
	  slotName: board.slotName,
	  lNet: pin.lNet,
	  gNet: pin.gNet,
	  module: board.id,
	};

	if (!bp.allNets[newNet.lNet]) bp.allNets[newNet.lNet] = {};
	bp.allNets[newNet.lNet][newNet.fullName] = newNet;

	// This is not particularly DRY.
	if (newNet.gNet) {
	  if (!bp.allNets[newNet.gNet]) bp.allNets[newNet.gNet] = {};
	  bp.allNets[pin.gNet][newNet.fullName] = newNet;
	}
	
	bp.allPins[newNet.fullName] = newNet;
      });
    });
  });

  // For each slot we have in the CRAM-to-net mapping, for each
  // net therein, install the net name in the slot.
  if (false) {
  Object.keys(cramDefs.slot)
    .forEach(slot => {
      Object.values(cramDefs.slot[slot])
	.forEach(net => {

	  bp.allNets[net.gNet][net.pin] = {
	  };

//	  bp.allPins[net.pin] = ;
	});
    });
  }
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
    console.log(`================================================================ STUB`);
    cx.board = ast;
    break;

  case 'Pin':
    cx.pin = ast;
    cx.pin.chip = cx.chip;
    cx.pin.fullName = cx.pin.chip.page.name + '.' + cx.pin.chip.name.name + '.' + cx.pin.pin;
    cx.pin.symbol = Symbol(cx.pin.fullName);
    cx.net = '';

    switch (cx.pin.net.nodeType) {
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

    if (!cx.chip.logic[cx.pin.dir] || !cx.chip.logic[cx.pin.dir][cx.pin.pin]) {
      console.log(`\
======>  ${cx.chip.name.name} undefined pin ${cx.pin.pin} ${cx.pin.dir} for ${cx.chip.type}`);
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
      const selected = t.ids.list[+result - 1]; // 1-origin indexing

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
    const resultStr = Math.trunc(eval(`${parseInt(L, 10)} ${t.nodeType} ${parseInt(R, 10)}`));
    const digits = Math.max(L.length, R.length);
    result = padValueToDigits(resultStr, digits)
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

  // libreoffice --convert-to csv ./cram-backplane.ods
  const cramDefs = readCRAMBackplane('cram-backplane.csv');
  fs.writeFileSync('bp.cram-defs', util.inspect(cramDefs, {depth: 99, breakLength: 90, maxArrayLength: null}));

  const needCheck =
        options.dumpNets ||
        options.dumpWireOr ||
        options.dumpUndriven;

  const parser = PEG.generate(fs.readFileSync('netlist.pegjs', 'utf8'), {
    output: 'parser',
    trace: options.traceParse,
  });

  // Parse the backplane definition and collapse the board page
  // substructure into a list of chips on the board.
  const bpAST = parseBackplanes(parser);

  const bp = {
    name: bpAST.name,
    slots: [],
  };

  bpAST.slots
    .filter(slot => slot.board && slot.board.pages && slot.board.id != 'ignore')
    .forEach(slot => {
      const slotName = slot.board.slotName;

      const board = {
	slotName,
	id: slot.board.id,
	comments: slot.board.comments,
	location: slot.board.location,

	macros: (slot.board.macros || []).reduce((macros, mac) =>
	  macros.concat(`${mac.id}=${mac.value}`),
	  []),

      };

      bp.slots[+slot.n] = board;
      board.chips = slot.board.pages.reduce((chips, page) => {

	(page.chips || []).forEach(astChip => {
	  const name = astChip.name.name;

	  if (chips[name]) {
	    console.error(`\
${slot.board.id}.${name} defined \
${util.inspect(astChip.location)} and previously \
${util.inspect(chips[name].location)}`);
	  }

	  chips[name] = {
	    type: astChip.type,
	    desc: astChip.desc,
	    page: page.name,
	    pdfRef: page.pdfRef,
	    location: astChip.location,
	    pins: astChip.pins,

	    pins: astChip.pins.map(pin => {

	      const pinsResult = {
		pin: pin.pin,
		dir: astDirToDir(pin.dir),
		fullName: pin.fullName,
		lNet: canonicalize(pin.netName),
		pdfRef: page.pdfRef,
		location: pin.location,
	      };

	      if (pin.bpPin) {	// If this local net connects to the backplane

		// Define backplane pin as <board>.<pin>[<slotName>].
		pinsResult.bpPin = `${slot.board.id}.${pin.bpPin}[${slotName}]`;

		// Note that this pin's net name is global.
		pinsResult.gNet = pinsResult.lNet;
	      }

	      return pinsResult;
	    }),
	  };
	});

	return chips;
      }, {});
    });

  fs.writeFileSync('bp.dump', util.inspect(bp, {depth: 99}));

  definePinsAndNets(bp, cramDefs);
  verilogifyNetNames(bp);
  dumpPins(bp);
  dumpVerilogNames(bp);
  if (options.dumpBackplane) dumpNets(bp);

  checkForSuspiciousSymbolNames(bp);
  
  return bp;
}


function readCRAMBackplane(fn) {
  return fs.readFileSync(fn, 'utf8')
    .split('\n')
    .filter((line, x) => line && x != 0)
    .reduce((cram, line) => {
      const [netUC, bitExpr, sliceExpr, pinFull] = line.split(',');
      const net = netUC.toLowerCase();
      const slice = parseInt(sliceExpr.split(/=/)[1]);
      const bit = parseInt(bitExpr.split(/\+/)[1]) + slice;
      const slot = pinFull.slice(2, 4);
      const bpPinName = `${pinFull[1]}${pinFull.slice(4)}`.toLowerCase();
      const pin = `crm.${bpPinName}[ebox.${slot}]`;

      if (isNaN(slot)) console.error(`${fn} bad slot number in line '${line}'`);

      const pPin = cram.bp[pin];
      if (pPin) console.error(`${fn} duplicate '${net}' pin '${pin}', was ${pPin.bit.toString().padStart(3)} '${pPin.net}'`);
      if (cram.nets[net]) console.error(`${fn} defines net '${net}' more than once`);
      cram.bp[pin] = {net, pin, slot};
      if (!cram.slot[slot]) cram.slot[slot] = {};
      cram.slot[slot][pin] = cram.bp[pin];
      cram.nets[net] = cram.bp[pin];
      return cram;
    }, {nets: {}, slot: {}, bp: {}, });
}


function astDirToDir(d) {
  return (d == '~<') ? 'I' : (d == '~>') ? 'D' : `???${d}`;
}


function verilogifyNetNames(bp) {
  bp.v2n = {};
  bp.n2v = {};

  Object.keys(bp.allNets)
    .filter(netName => netName != '%NC%')
    .forEach(netName => {
      const net = bp.allNets[netName];
      const vName = verilogify(netName);
      bp.v2n[vName] = netName;
      bp.n2v[netName] = vName;
    });

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
  function verilogify(n) {

    const characterSymbolNames = {
      '-': 'MS',
      '/': 'SL',
      ',': 'CM',
      '*': 'ST',
      '.': 'DT',
      '+': 'PL',
      '=': 'EQ',
      '#': 'NR',
      '(': 'LP',
      ')': 'RP',
      '%': 'PC',
      '^': 'CT',
      '<': 'LT',
      '>': 'GT',
      '&': 'ND',
      '[': 'LB',
      ']': 'RB',
    };

    // First convert -xxxx [lh] to xxxx [hl].
    n = canonicalize(n);

    n = n.replace(/ /g, '_');
    n = n.replace(/<-/g, 'GETS');
    n = n.replace(/([a-z][a-z][a-z0-9][0-9]*)-([a-z]+\d+)-(\d+)/g, '$1_$2_$3');
    n = n.replace(/(\d+)-(\d+)/g, '$1to$2');
    n = n.replace(/i\/o/g, 'IO');
    n = n.replace(/10\/11/g, '10_11');
    n = n.replace(/[-\/,*.+=#()%^<>&\[\]]/g, match => characterSymbolNames[match]);
    return n;
  }
}


function checkForSuspiciousSymbolNames(bp) {
  const suspicious = Object.keys(bp.allNets)
	.sort(netNameSort)
  // No connect
	.filter(n => n != '%NC%')
  // xxx [hl]
	.filter(n => !n.slice(-2).match(/ [hl]/))
  // xxx hi
	.filter(n => n.slice(-3) != ' hi' && n != 'hi')
  // local anonymous net naming convention
	.filter(n => !n.match(/([a-z][a-z][a-z0-9][0-9]*)-([a-z]+\d+)-(\d+)/))
	.map(n => `'${n}'`)
	.join('\n');

  if (suspicious) {
    console.error(`\

SUSPCIOUS symbol names:\n
${suspicious}

`);
  } else {
    console.log(`[no suspicious symbol names found]`);
  }
}


function dumpVerilogNames(bp) {
  fs.writeFileSync('bp.verilog-names',
		   Object.keys(bp.n2v)
		   .sort(netNameSort)
		   .map(nName => `${nName.padStart(50)}: ${bp.n2v[nName]}`).join('\n'))
}


function dumpPins(bp) {
  fs.writeFileSync('bp.pins',
		   Object.keys(bp.allPins)
		   .sort(slotPinSort)
		   .map(bpPin => `\
${bpPin}:
  ${Object.values(bp.allPins[bpPin])
    .map(pin => util.inspect(pin) /*`${pin.dir} ${pin.lNet.padEnd(35)}${pin.fullName}`*/)
    .join("\n  ")}`)
		   .join("\n"));

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
		   .join("\n"));

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


// Convert a net name of the form '- xyz l' to 'xyz h' or '- xyz h' to 'xyz l'.
function canonicalize(net) {

  if (net.slice(0, 1) == '-') {
    const lastChars = net.slice(-2);

    if (lastChars == ' h') {		// Switch to 'l'
      return `${net.slice(1, -2)} l`;
    } else if (lastChars == ' l') {	// Switch to 'h'
      return `${net.slice(1, -2)} h`;
    }
  }

  // If not negated net name just return as-is.
  return net;
}


function testCanonicalize() {
  test1('-ctl2 ar 00-11 clr h', 'ctl2 ar 00-11 clr l');
  test1('ctl2 ar 00-11 clr h', 'ctl2 ar 00-11 clr h');
  test1('ctl2 ar 00-11 clr l', 'ctl2 ar 00-11 clr l');
  test1('-ctl2 ar 00-11 clr FOO', '-ctl2 ar 00-11 clr FOO');
  test1('-ctl2 ar 00-11 clr l', 'ctl2 ar 00-11 clr h');

  function test1(a, sb) {

    if (canonicalize(a) != sb) {
      console.error(`ERROR: canonicalize('${a}') != '${sb}' is '${canonicalize(a)}'`);
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
      console.error(`ERROR: padValueToDigits(${v}, ${digits}) != '${sb}' is '${padValueToDigits(v, d)}'`);
    }
  }
}


function doTests() {
  testCanonicalize();
  testPadValueToDigits();
}

doTests();

module.exports.compile = compile;
module.exports.doTests = doTests;
