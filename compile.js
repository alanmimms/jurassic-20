'use strict';

const util = require('util');
const fs = require('fs');
const _ = require('lodash');
const PEG = require('pegjs');
const PEGUtil = require('pegjs-util');
const ASTY = require('asty');

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

console.log('AST:', result.ast.dump().replace(/\n$/, ''), 'utf8');

if (0) {
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
