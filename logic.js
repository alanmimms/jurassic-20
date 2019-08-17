'use strict';

// This builds an object whose properties are the chip types - e.g., '10181' for an ALU.
// These properties have object values of the form
// {
//   desc: 'short description',
//   '~<': ['input pin name1', 'input pin name 2', ...],
//   '~>': ['output pin name1', 'output pin name 2', ...],
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


function dev(desc, inputs, outputs) {
  return {desc,
          '~<': expand(inputs),
          '~>': expand(outputs)};
}


const logic = {
  '10101': {
    desc: '4xor/nor',
    '~<': expand('a1, b1, c1, d1, abcd2'),
    '~>': expand('nqa, qa, nqb, qb, nqc, qc, nqd, qd'),
    fn({i}) {
      return {
        qa: i.a1 || i.abcd2,
        qb: i.b1 || i.abcd2,
        qc: i.c1 || i.abcd2,
        qd: i.d1 || i.abcd2,
        nqa: !(i.a1 || i.abcd2),
        nqb: !(i.b1 || i.abcd2),
        nqc: !(i.c1 || i.abcd2),
        nqd: !(i.d1 || i.abcd2),
      };
    },

    '10103': {
      desc: '4xor',
      '~<': expand('a#1/2, b#1/2, c#1/2, d#1/2'),
      '~>': expand('qa, qb, nqc, qc, qd'),
      fn({i}) {
        return {
          qa: i.a1 || i.a2,
          qb: i.b1 || i.b2,
          qc: i.c1 || i.c2,
          nqc: !(i.c1 || i.c2),
          qd: i.d1 || i.d2,
        };
      },
    },

    '10104': {
      desc: '4xand', 
      '~<': expand('a#1/2, b#1/2, c#1/2, d#1/2'),
      '~>': expand('qa, qb, qc, qd, nqd'),
      fn ({i}) {
        return {
          qa: i.a1 && i.a2,
          qb: i.b1 && i.b2,
          qc: i.c1 && i.c2,
          qd: i.d1 && i.d2,
          nqd: !(i.d1 && i.d2),
        };
      },
    },

    '10105': {
      desc: '2-3-2 or/nor',
      '~<': expand('a#1/2, b#1/3, c#1/2'),
      '~>': expand('nqa, qa, nqb, qb, nqc, qc'),
      fn({i}) {
        return {
          qa: i.a1 || i.a2,
          nqa: !(i.a1 || i.a2),
          qb: i.b1 || i.b2 || i.b3,
          nqb: !(i.b1 || i.b2 || i.b3),
          qc: i.c1 || i.c2,
          nqc: !(i.c1 || i.c2),
        };
      },
    },

    '10107': {
      desc: '3xxor/xnor',
      '~<': expand('a#1/2, b#1/2, c#1/2'),
      '~>': expand('nqa, qa, nqb, qb, nqc, qc'),
      fn({i}) {
        return {
        };
      },
    },

    '10109': {
      desc: '4/5 or/nor',
      '~<': expand('a#1/4, b#1/5'),
      '~>': expand('nqa, qa, nqb, qb'),
      fn({i}) {
        return {
        };
      },
    },

    '10110': {
      desc: '2x or buffer',
      '~<': expand('a#1/3, b#1/3'),
      '~>': expand('qa#1/3, qb#1/3'),
      fn({i}) {
        return {
        };
      },
    },

    '10113': {
      desc: '4x xor buffer',
      '~<': expand('a#1/2, b#1/2, c#1/2, d#1/2, ne'),
      '~>': expand('qa, qb, qc, qd'),
      fn({i}) {
        return {
        };
      },
    },

    '10117': {
      desc: '2x2-3 or-and/or-and',
      '~<': expand('a#1/2, b#1/2, b3d3, c#1/3, d#1/2'),
      '~>': expand('nqab, qab, nqcd, qcd'),
      fn({i}) {
        return {
        };
      },
    },

    '10118': {
      desc: '2x3 or-and',
      '~<': expand('a#1/3, b#1/2, b3c3, c#1/2, d#1/3'),
      '~>': expand('qab, qcd'),
      fn({i}) {
        return {
        };
      },
    },

    '10121': {
      desc: '4-wide or-and/or-and',
      '~<': expand('a#1/3, b#1/2, b3c3, c#1/2, d#1/3'),
      '~>': expand('nq, q'),
      fn({i}) {
        return {
        };
      },
    },

    '10141': {
      desc: 'shft reg',
      '~<': expand('shft 0in, d/4, shft 3in, op#1/2, clk'),
      '~>': expand('q/4'),
      fn({i}) {
        return {
        };
      },
    },

    '10144': {
      desc: '256x1 ram',
      '~<': expand('a/8, nen#1/3, nwrite, d'),
      '~>': expand('q'),
      fn({i}) {
        return {
        };
      },
    },

    '10147': {
      desc: '128x1 ram',
      '~<': expand('a/7, nen#1/2, nwrite, d'),
      '~>': expand('q'),
      fn({i}) {
        return {
        };
      },
    },

    '10158': {
      desc: '4x2 mix',
      '~<': expand('d0/2, d1/2, d2/2, d3/2, sel'),
      '~>': expand('b/4'),
      fn({i}) {
        return {
        };
      },
    },

    '10160': {
      desc: 'parity',
      '~<': expand('d/12'),
      '~>': expand('odd'),
      fn({i}) {
        return {
        };
      },
    },

    '10161': {
      desc: 'decoder active low',
      '~<': expand('sel@3, nen#1/2'),
      '~>': expand('nq/8'),
      fn({i}) {
        return {
        };
      },
    },

    '10162': {
      desc: 'decoder',
      '~<': expand('sel@3, nen#1/2'),
      '~>': expand('q/8'),
      fn({i}) {
        return {
        };
      },
    },

    '10164': {
      desc: '8 mix',
      '~<': expand('d/8, sel@3, nen'),
      '~>': expand('b'),
      fn({i}) {
        return {
        };
      },
    },

    '10165': {
      desc: 'pri enc',
      '~<': expand('d/8, hold'),
      '~>': expand('any, q@3'),
      fn({i}) {
        return {
        };
      },
    },

    '10173': {
      desc: '2x4 mix latch',
      '~<': expand('d0/2, d1/2, d2/2, d3/2, sel1, hold'),
      '~>': expand('b/4'),
      fn({i}) {
        return {
        };
      },
    },

    '10174': {
      desc: '2x4 mix',
      '~<': expand('d0/4, d1/4, sel#1/2, nen'),
      '~>': expand('b/2'),
      fn({i}) {
        return {
        };
      },
    },

    '10176': {
      desc: '6xdff',
      '~<': expand('d/6, clk'),
      '~>': expand('q/6'),
      fn({i}) {
        return {
        };
      },
    },

    '10179': {
      desc: 'carry',
      '~<': expand('g@4, p@4, c in'),
      '~>': expand('c8 out, c2 out, g out, p out'),
      fn({i}) {
        return {
        };
      },
    },

    '10181': {
      desc: 'alu',
      '~<': expand('a@4, b@4, s@4, boole, c in'),
      '~>': expand('f@4, cg, cp, c out'),
      fn({i}) {
        return {
        };
      },
    },

    '10210': {
      desc: '2x3 or',
      '~<': expand('a#1/3, b#1/3'),
      '~>': expand('qa#1/3, qb#1/3'),
      fn({i}) {
        return {
        };
      },
    },

    'delay-line': {
      desc: 'delay buffer',
      '~<': expand('in'),
      '~>': expand('out'),
      fn({i}) {
        return {
        };
      },
    },
  },
};


if (require.main === module) console.log("logic:", require('util').inspect(logic));

module.exports = logic;
