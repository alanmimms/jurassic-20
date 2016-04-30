'use strict';

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
  makeAST: (line, col, offset, args) => asty.create.apply(asty, args).pos(line, col, offset),
});

console.log('result:',result);

if (result.ast)
  console.log('AST:', result.ast.dump().replace(/\n$/, ''), 'utf8');
