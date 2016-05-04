'use strict';

const util = require('util');
const fs = require('fs');
const _ = require('lodash');
const PEG = require('pegjs');
const PEGUtil = require('pegjs-util');
const ASTY = require('asty');


const dumpAST = true;


const asty = new ASTY();

const parser = PEG.buildParser(fs.readFileSync('netlist.pegjs', 'utf8'), {
//  trace: true,
});

const dpa = fs.readFileSync('dpa.netlist', 'utf8');

let result = PEGUtil.parse(parser, dpa, {
  startRule: 'netlist',
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


let macroEnv = {n: 12};

expandMacros(result.ast);



// Under all 'Pin' nodes evaluate and expand all '[]' nodes and join
// any adjacent IDchunks with them to form a single 'ID' node with
// attribute 'name'.
var pin, chip, page;
function expandMacros(ast) {

  if (!ast) return;

  const type = ast.type();
  const kids = ast.childs();

  switch (type) {
  case 'Chip':
    chip = ast;
    console.log(`\nChip ${chip.get('name')}:  ${chip.get('desc')}`);
    kids.forEach(k => expandMacros(k));
    break;

  case 'Page':
    page = ast;
    console.log(`\nPage ${page.get('name')}, pdfRef ${page.get('pdfRef')}`);
    kids.forEach(k => expandMacros(k));
    break;

  case 'Netlist':
    kids.forEach(k => expandMacros(k));
    break;

  case 'Pin':
    pin = ast;
    var expansion = '';

    kids.forEach(pinKid => {

      switch (pinKid.type()) {
      case 'ID':
	pinKid.childs().forEach(idKid => {

	  switch (idKid.type()) {
	  case '[]':		// Macro
	    expansion += evalExpr(idKid);
	    break;

	  case 'IDchunk':		// Piece of an identifier
	    expansion += idKid.get('name');
	    break;

	  default:
	    break;
	  }
	});

	break;

      case '[]':		// Macro
	expansion += evalExpr(pinKid);
	break;

      case '%NC%':
	expansion += '%NC%';
	break;

      default:
	console.log(`Pin child node of unknown flavor '${pinKid.type()}' IGNORED`);
	return;
      }

      console.log(`Chip ${chip.get('name')} pin ${pin.get('name')}: '${expansion}'.`);
      pin.set('connects-to', expansion);
    });

    break;

  default:
    break;
  }
  
  if (type === 'ID' || type === '%NC%') {

    if (type === 'ID') {
    } else {
      expansion = '%NC%';
    }
    
//    ast.parent().del([ast]);
  } else {
    ast.childs().forEach(k => expandMacros(k));
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


console.log(`Unconnected node names:`);
