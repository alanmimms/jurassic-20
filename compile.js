'use strict';

const util = require('util');
const fs = require('fs');
const _ = require('lodash');
const PEG = require('pegjs');
const PEGUtil = require('pegjs-util');
const ASTY = require('asty');
const logic = require('./logic.js');

const dumpAST = true;


const asty = new ASTY();

const parser = PEG.buildParser(fs.readFileSync('netlist.pegjs', 'utf8'), {
//  trace: true,
});

const dpa = fs.readFileSync('dpa.board', 'utf8');

let result = PEGUtil.parse(parser, dpa, {
  startRule: 'board',
  makeAST: (line, col, offset, args) => 
    asty.create.apply(asty, args).pos(line, col, offset),
});

//console.log('result:', util.inspect(result, {depth: 9, colors: false}));

if (result.error !== null) {
    console.log("ERROR: Parsing Failure:\n" +
        PEGUtil.errorMessage(result.error, true).replace(/^/mg, "ERROR: "))
  process.exit(1);
}

if (dumpAST) {
  let f = fs.openSync('before.evaluation', 'w');
  fs.writeSync(f, result.ast.dump().replace(/\n$/, ''));
  fs.closeSync(f);
}


var macroEnv = {n: 12};
var netRefs = {};

expandMacros(result.ast);


// Under all 'Pin' nodes evaluate and expand all '[]' nodes and join
// any adjacent IDchunks with them to form a single 'ID' node with
// attribute 'name'.
var net, dir, pin, chip, page;
function expandMacros(ast) {

  if (!ast) return;

  const type = ast.type();
  const kids = ast.childs();

  switch (type) {
  case 'Chip':
    chip = ast;
    chip.logic = logic[chip.get('type')];

    if (!chip.logic) {
      // Provide dummy entry just so we can go on
      chip.logic = {'<': [], '>': [], '<>': []};
      console.log(`${page.get('name')}.${chip.get('name')} ` +
		  `undefined logic device '${chip.get('type')}'`);
    }
    
//  console.log(`\n${page.get('name')}.${chip.get('name')}: ${chip.get('type')} ${chip.get('desc')}`);
    kids.forEach(k => expandMacros(k));
    break;

  case 'Page':
    page = ast;
//    console.log(`\nPage ${page.get('name')}, pdfRef ${page.get('pdfRef')}`);
    kids.forEach(k => expandMacros(k));
    break;

  case 'Board':
    kids.forEach(k => expandMacros(k));
    break;

  case 'Pin':
    pin = ast;
    net = '';
    dir = pin.get('dir');
    'dir name'.split(/\s+/).forEach(p => pin[p] = pin.get(p));

    kids.forEach(pinKid => {

      switch (pinKid.type()) {
      case 'ID':
	pinKid.childs().forEach(idKid => {

	  switch (idKid.type()) {
	  case '[]':		// Macro
	    net += evalExpr(idKid);
	    break;

	  case 'IDchunk':		// Piece of an identifier
	    net += idKid.get('name');
	    break;

	  default:
	    break;
	  }
	});

	break;

      case '[]':		// Macro
	net += evalExpr(pinKid);
	break;

      case '%NC%':
	net += '%NC%';
	break;

      default:
	console.log(`Pin child node of unknown flavor '${pinKid.type()}' IGNORED`);
	return;
      }

      if (!chip.logic[dir] || chip.logic[dir].indexOf(pin.name) < 0)
	  console.log(`  ${chip.get('name')} undefined pin ${pin.name} ${dir} ` +
		      `for ${chip.get('type')}`);

      pin.net = net;
      pin.set('net', net);
    });

    /*
    if (chip.get('name') === 'e33' || chip.get('name') === 'e29')
      console.log(`  ${chip.get('name')}.${pin.name} ${dir} ${net}`);
     */
    
    if (!netRefs[net]) netRefs[net] = {[dir]: []};
    if (!netRefs[net][dir]) netRefs[net][dir] = {};
    netRefs[net][dir][pin] = pin;
    break;

  default:
    break;
  }
  
  if (type !== 'ID' && type !== '%NC%') ast.childs().forEach(k => expandMacros(k));
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
  fs.writeSync(f, result.ast.dump().replace(/\n$/, ''));
  fs.closeSync(f);
}


////////////////////////////////////////////////////////////////

if (0) {			// Old crufty debugging shit
  result.ast.walk((node, depth, parent, when) => {
    let as = ' ';
    let name = node.get('name');
    if (name) as += `'${name}'`;

    if (node.type() === 'ID') {
      as += node.childs().map(c => c.type()).join(', ');
    } else if (node.type() === '[]') {
      as += node.childs().map(p => node.type()).join(', ');
    }
    
    console.log(_.padStart('', depth*2) + node.type() + as);
    return false;
  });

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
