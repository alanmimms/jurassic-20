'use strict';

// This builds an object whose properties are the chip types - e.g., '10181' for an ALU.
// These properties have object values of the form
// {
//   desc: 'short description',
//   '<': ['input pin name1', 'input pin name 2', ...],
//   '>': ['output pin name1', 'output pin name 2', ...],
// )
const _ = require('lodash');


const expand = s => _.flatten(
  s.split(/,\s*/).map(el => {
    let m;

    // Form 'xxx[#B]/N' where '[#B]' is optional base of iteration and
    // 'N' is number of iterations.
    // E.g., 'xyz#3/7' => xyz3 xyz4 xyz5 xyz6
    // E.g., 'abc/3' => abc0 abc1 abc2
    if ((m = el.match(/([^#\/]+)(?:#(\d+))?\/(\d+)/))) {
      let b = +(m[2] || 0);
      let rangeEnd = b + +m[3];
      return _.range(b, rangeEnd).map(n => m[1] + n);
    }

    // Form 'xxx[#B]@N' where '[#B]' is optional base of iteration and
    // 'N' is number of powers of 2 to produce.
    // E.g., 'xyz#100@5' => xyz101 xyz102 xyz104 xyz108 xyz116
    // E.g., 'abc@5' => abc1 abc2 abc4 abc8 abc16
    if ((m = el.match(/([^#@]+)(?:#(\d+))?@(\d+)/))) {
      let a = [];
      let b = +(m[2] || 0);
      let n = +m[3];
      for (let k = 0; k < n; ++k) a.push(m[1] + (b + (1 << k)));
      return a;
    }

    // Otherwise, it's just a name.
    return el;
  }));


const dev = (desc, inputs, outputs) => ({desc, '<': expand(inputs), '>': expand(outputs)});


const logic = {
  '10101': dev('4xor/nor', 'a1, b1, c1, d1, abcd2', 'nqa, qa, nqb, qb, nqc, qc, nqd, qd'),
  '10105': dev('3x2-3-2 or/nor', 'a#1/2, b#1/3, c#1/2', 'nqa, qa, nqb, qb, nqc, qc'),
  '10107': dev('3x2 xor/xnor', 'a#1/2, b#1/2, c#1/2', 'nqa, qa, nqb, qb, nqc, qc'),
  '10109': dev('2x2/4 or/nor', 'a#1/4, b#1/5', 'nqa, qa, nqb, qb'),
  '10110': dev('2x or buffer', 'a#1/3, b#1/3', 'qa#1/3, qb#1/3'),
  '10141': dev('shft reg', 'shft 0in, d/4, shft 3in, op#1/2, clk', 'q/4'),
  '10147': dev('128x1 ram', 'a/7, nen#1/2, nwrite, d', 'q'),
  '10158': dev('4x2 mix', 'd0/2, d1/2, d2/2, d3/2, sel', 'b/4'),
  '10160': dev('parity', 'd/12', 'odd'),
  '10164': dev('8 mix', 'd/8, sel@3, en', 'b'),
  '10174': dev('2x4 mix', 'd0/4, d1/4, sel#1/2, nen', 'b/2'),
  '10181': dev('alu', 'a@4, b@4, s@4, boole, c in', 'f@4, cg, cp, c out'),
  '10210': dev('2x3 or', 'a#1/3, b#1/3', 'qa#1/3, qb#1/3'),
};

if (require.main === module) console.log("logic:", require('util').inspect(logic));

module.exports = logic;
