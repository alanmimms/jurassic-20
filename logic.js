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

    init() {},
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

    init() {},
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

    init() {},
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

    init() {},
  },

  '10107': {
    desc: '3xxor/xnor',
    '~<': expand('a#1/2, b#1/2, c#1/2'),
    '~>': expand('nqa, qa, nqb, qb, nqc, qc'),

    fn({i}) {
      return {
        qa: i.a1 || i.a2,
        nqa: !(i.a1 || i.a2),
        qb: i.b1 || i.b2,
        nqb: !(i.b1 || i.b2),
        qc: i.c1 || i.c2,
        nqc: !(i.c1 || i.c2),
      };
    },

    init() {},
  },

  '10109': {
    desc: '4/5 or/nor',
    '~<': expand('a#1/4, b#1/5'),
    '~>': expand('nqa, qa, nqb, qb'),

    fn({i}) {
      return {
        qa: i.a1 || i.a2 || i.a3 || i.a4,
        nqa: !(i.a1 ||  i.a2 || i.a3 || i.a4),
        qb: i.b1 || i.b2 || i.b3 || i.b4 || i.b5,
        nqb: !(i.b1 || i.b2 || i.b3 || i.b4 || i.b5),
      };
    },
    init() {},
  },

  '10110': {
    desc: '2x or buffer',
    '~<': expand('a#1/3, b#1/3'),
    '~>': expand('qa#1/3, qb#1/3'),

    fn({i}) {
      return {
        qa1: i.a1 || i.a2 || i.a3,
        qa2: i.a1 || i.a2 || i.a3,
        qa3: i.a1 || i.a2 || i.a3,
        qb1: i.b1 || i.b2 || i.b3,
        qb2: i.b1 || i.b2 || i.b3,
        qb3: i.b1 || i.b2 || i.b3,
      };
    },

    init() {},
  },

  '10113': {
    desc: '4x xor buffer',
    '~<': expand('a#1/2, b#1/2, c#1/2, d#1/2, ne'),
    '~>': expand('qa, qb, qc, qd'),

    fn({i}) {
      return {
        qa: !i.ne && !!(i.a1 ^ i.a2),
        qb: !i.ne && !!(i.b1 ^ i.b2),
        qc: !i.ne && !!(i.c1 ^ i.c2),
        qd: !i.ne && !!(i.d1 ^ i.d2),
      };
    },

    init() {},
  },

  '10117': {
    desc: '2x2-3 or-and/or-and',
    '~<': expand('a#1/2, b#1/2, b3d3, c#1/3, d#1/2'),
    '~>': expand('nqab, qab, nqcd, qcd'),

    fn({i}) {
      return {
        qab: (i.a1 || i.a2) && (i.b1 || i.b2 || i.b3d3),
        nqab: !((i.a1 || i.a2) && (i.b1 || i.b2 || i.b3d3)),
        qcd: (i.c1 || i.c2) && (i.d1 || i.d2 || i.b3d3),
        nqcd: !((i.c1 || i.c2) && (i.d1 || i.d2 || i.b3d3)),
      };
    },

    init() {},
  },

  '10118': {
    desc: '2x3 or-and',
    '~<': expand('a#1/3, b#1/2, b3c3, c#1/2, d#1/3'),
    '~>': expand('qab, qcd'),

    fn({i}) {
      return {
        qab: (i.a1 || i.a2 || i.a3) && (i.b1 || i.b2 || i.b3c3),
        qcd: (i.c1 || i.c2 || i.b3c3) && (i.d1 || i.d2 || i.d3),
      };
    },

    init() {},
  },

  '10121': {
    desc: '4-wide or-and/or-and',
    '~<': expand('a#1/3, b#1/2, b3c3, c#1/2, d#1/3'),
    '~>': expand('nq, q'),

    fn({i}) {
      return {
        qab: ((i.a1 || i.a2 || i.a3) &&
              (i.b1 || i.b2 || i.b3c3) &&
              (i.c1 || i.c2 || i.b3c3) &&
              (i.d1 || i.d2 || i.d3)),
        nqab: !((i.a1 || i.a2 || i.a3) &&
                (i.b1 || i.b2 || i.b3c3) &&
                (i.c1 || i.c2 || i.b3c3) &&
                (i.d1 || i.d2 || i.d3)),
      };
    },

    init() {},
  },

  '10141': {
    desc: 'shft reg',
    '~<': expand('shft 0in, d/4, shft 3in, op#1/2, clk'),
    '~>': expand('q/4'),

    fn({i}) {
      const op = (+i.op0 << 1) | +i.op1;

      switch (op) {
      case 0:                 // Parallel load
        this.d0 = i.do;
        this.d1 = i.d1;
        this.d2 = i.d2;
        this.d3 = i.d3;
        break;

      case 1:                 // Shift right
        this.d0 = this.d1;
        this.d1 = this.d2;
        this.d2 = this.d3;
        this.d3 = i['shft 3in'];
        break;

      case 2:                 // Shift left
        this.d3 = this.d2;
        this.d2 = this.d1;
        this.d1 = this.d0;
        this.d0 = i['shft 0in'];
        break;

      case 3:                 // Stop shift
        break;                // Noop
      }
      
      return this;
    },

    init() {
      this.d0 = this.d1 = this.d2 = this.d3 = false;
    },
  },

  '10144': {
    desc: '256x1 ram',
    '~<': expand('a/8, nen#1/3, nwrite, d'),
    '~>': expand('q'),

    fn({i}) {
      const a =
            +i.a0 << 0 |
            +i.a1 << 1 | 
            +i.a2 << 2 |
            +i.a3 << 3 |
            +i.a4 << 4 |
            +i.a5 << 5 |
            +i.a6 << 6 |
            +i.a7 << 7;
      if (!i.nwrite && !i.nen1 && !i.nen2 && !i.nen3) this.ram[a] = i.d;
      const d = (!i.nwrite || i.nen1 || i.nen2 || i.nen3)? false : this.ram[a];
      return {d};
    },

    init() {
      for (let k = 0; k < 256; ++k) this.ram[k] = false;
    },
  },

  '10147': {
    desc: '128x1 ram',
    '~<': expand('a/7, nen#1/2, nwrite, d'),
    '~>': expand('q'),

    fn({i}) {
      const a =
            +i.a0 << 0 |
            +i.a1 << 1 | 
            +i.a2 << 2 |
            +i.a3 << 3 |
            +i.a4 << 4 |
            +i.a5 << 5 |
            +i.a6 << 6;
      if (!i.nwrite && !i.nen1 && !i.nen2) this.ram[a] = i.d;
      const d = (!i.nwrite || i.nen1 || i.nen2)? false : this.ram[a];
      return {d};
    },

    init() {
      for (let k = 0; k < 128; ++k) this.ram[k] = false;
    },
  },

  '10158': {
    desc: '4x2 mix',
    '~<': expand('d0/2, d1/2, d2/2, d3/2, sel'),
    '~>': expand('b/4'),

    fn({i}) {
      const b1 = i.sel ? i.d00 : i.d01;
      const b2 = i.sel ? i.d10 : i.d11;
      const b3 = i.sel ? i.d20 : i.d21;
      const b4 = i.sel ? i.d30 : i.d31;
      return {b1, b2, b3, b4};
    },

    init() {},
  },

  '10160': {
    desc: 'parity',
    '~<': expand('d/12'),
    '~>': expand('odd'),

    fn({i}) {
      return {
        odd: !!((+i.d0 + +i.d1 + +i.d2 + +i.d3 + +i.d4 + +i.d5 + +i.d6 + +i.d7) & 1),
      };
    },

    init() {},
  },

  '10161': {
    desc: 'decoder active low',
    '~<': expand('sel@3, nen#1/2'),
    '~>': expand('nq/8'),

    fn({i}) {
      let nq = Array(8).fill(true);

      if (!i.nen1 && !i.nen2) nq[+i.sel1 << 0 | +i.sel2 << 1 | +i.sel4 << 2] = false;

      return {
        nq0: nq[0],
        nq1: nq[1],
        nq2: nq[2],
        nq3: nq[3],
        nq4: nq[4],
        nq5: nq[5],
        nq6: nq[6],
        nq7: nq[7],
      };
    },

    init() {},
  },

  '10162': {
    desc: 'decoder',
    '~<': expand('sel@3, nen#1/2'),
    '~>': expand('q/8'),

    fn({i}) {
      let q = Array(8).fill(false);

      if (!i.nen1 && !i.nen2) q[+i.sel1 << 0 | +i.sel2 << 1 | +i.sel4 << 2] = false;

      return {
        q0: q[0],
        q1: q[1],
        q2: q[2],
        q3: q[3],
        q4: q[4],
        q5: q[5],
        q6: q[6],
        q7: q[7],
      };
    },

    init() {},
  },

  '10164': {
    desc: '8 mix',
    '~<': expand('d/8, sel@3, nen'),
    '~>': expand('b'),

    fn({i}) {
      let b;

      if (i.nen) {
        b = false;
      } else {
        const a = +i.sel1 << 0 | +i.sel2 << 1 | +i.sel4 << 2;
        b = i['d' + a];
      }
      
      return {b};
    },

    init() {},
  },

  '10165': {
    desc: 'pri enc',
    '~<': expand('d/8, hold'),
    '~>': expand('any, q@3'),

    fn({i}) {
      let k;
      let any, q1, q2, q4;

      for (k = 0; k < 8; ++k) 
        if (i['d' + k]) break;

      if (k < 8) {
        any = true;
        q1 = !!+(k & 1);
        q2 = !!+(k & 2);
        q4 = !!+(k & 4);
      } else {
        any = false;
        q1 = q2 = q4 = false;
      }

      return {any, q1, q2, q4};
    },

    init() {},
  },

  '10173': {
    desc: '2x4 mix latch',
    '~<': expand('d0/2, d1/2, d2/2, d3/2, sel1, hold'),
    '~>': expand('b/4'),

    fn({i}) {

      if (!i.hold) {

        if (i.sel1) {
          this.b0 = i.d01;
          this.b1 = i.d11;
          this.b2 = i.d21;
          this.b3 = i.d31;
        } else {
          this.b0 = i.d00;
          this.b1 = i.d10;
          this.b2 = i.d20;
          this.b3 = i.d30;
        }
      }

      return this;
    },

    init() {
      this.b0 = this.b1 = this.b2 = this.b3 = false;
    },
  },

  '10174': {
    desc: '2x4 mix',
    '~<': expand('d0/4, d1/4, sel#1/2, nen'),
    '~>': expand('b/2'),

    fn({i}) {
      let b0, b1;

      if (!i.nen) {
        b0 = b1 = false;
      } else {
        const a = +i.sel1 << 0 | +i.sel2;
        b0 = i['d0' + a];
        b1 = i['d1' + a];
      }

      return {b0, b1};
    },

    init() {},
  },

  '10176': {
    desc: '6xdff',
    '~<': expand('d/6, clk'),
    '~>': expand('q/6'),

    fn({i}) {
      
      // Only state changes on positive going clock edge
      if (i.clk && !this.clkPrev) {
        this.d0 = i.q0;
        this.d1 = i.q1;
        this.d2 = i.q2;
        this.d3 = i.q3;
        this.d4 = i.q4;
        this.d5 = i.q5;
      }

      this.clkPrev = i.clk;
      return this;
    },

    init() {
      this.clkPrev = false;
      this.q0 = this.q1 = this.q2 = this.q3 = this.q4 = this.q5 = false;
    },
  },

  '10179': {
    desc: 'carry',
    '~<': expand('g@4, p@4, c in'),
    '~>': expand('c8 out, c2 out, g out, p out'),

    fn({i}) {
      const cn = i['c in'];
      const p = i.p0 || i.p1 || i.p2 || i.p3;
      const g = (i.g0 || i.p1 || i.p2 || i.p3) &&
            (i.g1 || i.p2 || i.p3) && 
            (i.g2 || i.p3) && 
            i.g3;
      const c2 = (cn || i.p0 || i.p1) && (i.g0 || i.p1) && i.g1;
      const c8 = (cn || i.p0 || i.p1 || i.p2 || i.p3) && 
            (i.g0 || i.p1 || i.p2 || i.p3) &&
            (i.g1 || i.p2 || i.p3) && 
            (i.g2 || i.p3) && 
            i.g3;

      return {
        'c8 out': c8,
        'c2 out': c2,
        'g out': g,
        'p out': p,
      };
    },

    init() {},
  },

  '10181': {
    desc: 'alu',
    '~<': expand('a@4, b@4, s@4, boole, c in'),
    '~>': expand('f@4, cg, cp, c out'),

    fn({i}) {
      let f, cg, cp, c4;
      const c0 = +i['c in'];
      const a = +i.a0 << 0 | +i.a1 << 1 | +i.a2 << 2 | +i.a3 << 3;
      const b = +i.b0 << 0 | +i.b1 << 1 | +i.b2 << 2 | +i.b3 << 3;
      const s = +i.s0 << 0 | +i.s1 << 1 | +i.s2 << 2 | +i.s3 << 3;

      if (i.boole) {
        c4 = false;

        switch (s) {
        case 0:  f = a ^ 0b1111;                   break;
        case 1:  f = (a ^ 0b1111) | (b ^ 0b1111);  break;
        case 2:  f = (a ^ 0b1111) | b;             break;
        case 3:  f = 0b1111;                       break;
        case 4:  f = (a ^ 0b1111) & (b ^ 0b1111);  break;
        case 5:  f = b ^ 0b1111;                   break;
        case 6:  f = a ^ b ^ 0b1111;               break;
        case 7:  f = a | (b & 0b1111);             break;
        case 8:  f = (a & 0b1111) & b;             break;
        case 9:  f = a ^ b;                        break;
        case 10: f = b;                            break;
        case 11: f = a | b;                        break;
        case 12: f = 0;                            break;
        case 13: f = a & (b ^ 0b1111);             break;
        case 14: f = a & b;                        break;
        case 15: f = a;                            break;
        }
      } else {

        function alu({a, b, s, m, c0}) {
          const [a3, a2, a1, a0] = bitExplode(a);
          const [b3, b2, b1, b0] = bitExplode(b);
          const [s3, s2, s1, s0] = bitExplode(s);

        //const s3all = (s & 8) ? 0b1111 : 0;
          // No need to clean to 4 bits bc AND at pt of use
          const s3all = -((s >>> 3) & 1);
          const s2all = -((s >>> 2) & 1);
          const s1all = -((s >>> 1) & 1);
          const s0all = -(s & 1);
          const mall = -m;
          const notb = b ^ 0b1111;
          let gg = (s3all | a | b) & (s2all | a | notb) & 0b1111;
          let pp = (s1all | notb) & (s0all | b) & a & 0b1111;

          // XXX Not complete
          let ff = ((0b1111 ^ (mall | (gg << 1) & 0x1110 | c0)) | // nor(m,c0)...nor(m,g2)
                    (pp ^ gg) ^ 0b1111          // xor(g0,p0)...xor(g3,p3)
                    // TODO: AND result with 0b1111 to clean high bits from `mall`
                   );

          const f0 = nxor(nor(m, c0),
                          xor(g0, p0));

          const f1 = nxor(or(nor(m, g0),
                             nor(m, p0, c0)),
                          xor(g1, p1));

          const f2 = nxor(or(nor(m, g1),
                             nor(m, p1, g0),
                             nor(m, p1, p0, c0)),
                          xor(g2, p2));

          const f3 = nxor(or(nor(m, g2),
                             nor(m, p2, g1),
                             nor(m, p2, p1, g0),
                             nor(m, p2, p1, p0, c0)),
                          xor(g3, p3));

        //const p = or(p3, p2, p1, p0);
          const p = +!!pp;
          const gc = or(not(g3),
                        nor(p3, g2), 
                        nor(p3, p2, g1), 
                        nor(p3, p2, p1, g0));
          const g = not(gc);
          const c4 = or(gc, nor(p3, p2, p1, p0, c0));

          const f = bitJoin(f3, f2, f1, f0);

          return {f, g, p, c4};
        }

        switch (s) {
        case 0:  f = a;                             break;
        case 1:  f = a + (a & (b ^ 0b1111));        break;
        case 2:  f = a + (a & (b ^ 0b1111));        break;
        case 3:  f = a + a;                         break;
        case 4:  f = (a | b);                       break;
        case 5:  f = a + b + (a & (b ^ 0b1111));    break;
        case 6:  f = a + b;                         break;
        case 7:  f = (a | b) + a;                   break;
        case 8:  f = (a | (b ^ 0b1111));            break;
        case 9:  f = a - b - 1;                     break;
        case 10: f = (a | (b ^ 0b1111)) + (a & b);  break;
        case 11: f = (a | (b ^ 0b1111)) + a;        break;
        case 12: f = 0b1111;                        break;
        case 13: f = (a & (b ^ 0b1111)) - 1;        break;
        case 14: f = (a & b) - 1;                   break;
        case 15: f = a - 1;                         break;
        }
      }

      f += c0;
      c4 = f >> 4;
      f &= 0b1111;
      return {f, cg, cp, 'c out': c4};
    },

    init() {},
  },

  '10210': {
    desc: '2x3 or',
    '~<': expand('a#1/3, b#1/3'),
    '~>': expand('qa#1/3, qb#1/3'),

    fn({i}) {
      const qa = i.a1 | i.a2 | i.a3;
      const qb = i.b1 | i.b2 | i.b3;
      return {
        qa1: qa,
        qa2: qa,
        qa3: qa,
        qb1: qb,
        qb2: qb,
        qb3: qb,
      };
    },

    init() {},
  },

  'delay-line': {
    desc: 'delay buffer',
    '~<': expand('in'),
    '~>': expand('out'),

    fn({i}) {
      return {
        out: i.in,              // XXX needs to be actually delayed?
      };
    },

    init() {},
  },
};


if (require.main === module) console.log("logic:", require('util').inspect(logic));

module.exports = logic;
