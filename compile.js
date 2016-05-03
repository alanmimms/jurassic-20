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
  let f = fs.openSync('out', 'w');
  fs.writeSync(f, result.ast.dump().replace(/\n$/, ''));
  fs.closeSync(f);
}


let macroEnv = {n: 12};

expandMacros(result.ast, macroEnv);



// Expand all '[]' nodes and join the adjacent IDchunks with them to
// form a single 'ID' node with attribute 'name'.
function expandMacros(ast, env) {

  if (!ast) return;  

  // Every 'ID' might have macros and a bunch of 'IDchunk' children. Expand-o-rama.
  if (ast.type() === 'ID') {

    ast.childs().forEach(k => {

      switch (k.type()) {
      case '[]':		// Macro

	break;

      case 'IDchunk':		// Piece of an identifier
	break;

      default:
	console.log(`ID with child of unknown flavor '${k.type()}' IGNORED`);
	break;
      }
    });
  } else {
    ast.childs().forEach(k => expandMacros(k, env));
  }
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
