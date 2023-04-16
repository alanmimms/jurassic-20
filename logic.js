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

    // Form 'xxx=p' where xxx is pin name and p is pin number.
    // Syntax DOES NOT permit whitespace surrounding the '='.
    if ((m = el.match(/(?<name>[^=]+)=(?<pin>\d+)/))) {
      const {name, pin} = m.groups;
      return {name, pin};
    } else {
      console.error(`Bad pin definition syntax "${el}".`);
      return {name: '???', pin: 0};
    }
  }))
      .reduce((o, e) => {o[e.pin] = e; return o}, {});


function dev(desc, inputs, outputs) {
  return {desc,
          '~<': expand(inputs),
          '~>': expand(outputs)};
}


const logic = {
  '10101': {
    desc: '4xor/nor',
    '~<': expand('a1=4, b=7, c1=10, d1=13, abcd2=12'),
    '~>': expand('nqa=2, qa=5, nqb=3, qb=6, nqc=14, qc=11, nqd=15, qd=9'),

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
    '~<': expand('a1=4, a2=5, b1=6, b2=7, c1=12, c2=13, d1=10, d2=11'),
    '~>': expand('qa=2, qb=3, qc=15, nqc=9, qd=14'),

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
    '~<': expand('a1=4,a2=5, b1=6,b2=7, c1=10,c2=11, d1=12,d2=13'),
    '~>': expand('qa=2, qb=3, qc=14, qd=15, nqd=9'),

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
    '~<': expand('a1=4,a2=5, b1=9,b2=10,b3=11, c1=13,c2=12'),
    '~>': expand('nqa=3, qa=2, nqb=6, qb=7, nqc=14, qc=15'),

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
    '~<': expand('a1=4,a2=5, b1=9,b2=7, c1=14,c2=15'),
    '~>': expand('nqa=2, qa=3, nqb=11, qb=10, nqc=12, qc=13'),

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
    '~<': expand('a1=4,a2=5,a3=6,a4=7, b1=9,b2=10,b3=11,b4=12,b5=13'),
    '~>': expand('nqa=3, qa=2, nqb=14, qb=15'),

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
    '~<': expand('a1=5,a2=6,a3=7, b1=9,b2=10,b3=11'),
    '~>': expand('qa1=2,qa2=3,qa3=4, qb1=12,qb2=13,qb3=14'),

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
    '~<': expand('a1=4,a2=5, b1=6,b2=7, c1=10,c2=11, d1=12,d2=13, ne=9'),
    '~>': expand('qa=2, qb=3, qc=14, qd=15'),

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
    '~<': expand('a1=4,a2=5, b1=6,b2=7, c1=10,c2=11, d1=12,d2=13, b3d3=9'),
    '~>': expand('nqab=3, qab=2, nqcd=14, qcd=15'),

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
    '~<': expand('a1=3,a2=4,a3=5, b1=6,b2=7, c1=10,c2=11, d1=12,d2=13,d3=14, b3c3=9'),
    '~>': expand('qab=2, qcd=15'),

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
    '~<': expand('a1=4,a2=5,a3=6, b1=7,b2=9, c1=11,c2=12, d1=13,d2=14,d3=15, b3c3=10'),
    '~>': expand('nq=3, q=2'),

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
    '~<': expand('shft 0in=13, d0=12,d1=11,d2=9,d3=6, shft 3in=5, op1=10,op2=7, clk=4'),
    '~>': expand('q0=14,q1=15,q2=2,q3=3'),

    fn({i}) {
      const op = (+i.op0 << 1) | +i.op1;

      switch (op) {
      case 0:                 // Parallel load
        this.d0 = i.d0;
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
    '~<': expand('a0=1,a1=2,a2=3,a3=4,a4=9,a5=10,a6=11,a7=12, nen1=5,nen2=6,nen3=7, nwrite=14, d=13'),
    '~>': expand('q=15'),

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
    '~<': expand('a0=4,a1=3,a2=2,a3=5,a4=6,a5=7,a6=10, nen1=13,nen2=14, nwrite=12, d=11'),
    '~>': expand('q=15'),

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
    '~<': expand('d00=6,d01=5, d10=4,d11=3, d20=13,d21=12, d30=11,d31=10, sel=9'),
    '~>': expand('b0=1,b1=2,b2=15,b3=14'),

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
    '~<': expand('d0=3,d1=4,d2=5,d3=6,d4=7,d5=9,d6=10,d7=11,d8=12,d9=13,d10=14,d11=15'),
    '~>': expand('odd=2'),

    fn({i}) {
      return {
        odd: !!((+i.d0 + +i.d1 + +i.d2 + +i.d3 + +i.d4 + +i.d5 +
		 +i.d6 + +i.d7 + +i.d8 + +i.d9 + +i.d10 + +i.d11) & 1),
      };
    },

    init() {},
  },

  '10161': {
    desc: 'decoder active low',
    '~<': expand('sel4=14,sel2=9,sel1=7, nen1=15,nen2=2'),
    '~>': expand('nq0=6,nq1=5,nq2=4,nq3=3,nq4=13,nq5=12,nq6=11,nq7=10'),

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
    '~<': expand('sel4=14,sel2=9,sel1=7, nen1=15,nen2=2'),
    '~>': expand('q0=6,q1=5,q2=4,q3=3,q4=13,q5=12,q6=11,q7=10'),

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
    '~<': expand('d0=6,d1=5,d2=4,d3=3,d4=11,d5=12,d6=13,d7=14, sel4=10,sel2=9,sel1=7, nen=2'),
    '~>': expand('b=15'),

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
    '~<': expand('d0=5,d1=7,d2=13,d3=10,d4=11,d5=12,d6=9,d7=6, hold=4'),
    '~>': expand('any=14, q4=15,q2=2,q1=3'),

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
    '~<': expand('d00=5,d01=6, d10=3,d11=4, d20=12,d21=13, d30=10,d31=11, sel1=9, hold=7'),
    '~>': expand('b0=1,b1=2,b2=15,b3=14'),

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
    '~<': expand('d00=3,d01=5,d02=4,d03=6, d10=13,d11=11,d12=12,d13=10, sel2=9,sel1=7, nen=14'),
    '~>': expand('b0=2,b1=15'),

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
    '~<': expand('d0=5,d1=6,d2=7,d3=10,d4=11,d6=12, clk=9'),
    '~>': expand('q0=2,q1=3,q2=4,q3=13,q4=14,q5=15'),

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
    desc: 'carry skipper',
    '~<': expand('g8=5,p8=13,g4=9,p4=12, g2=7,p2=10,g1=4,p1=14, c in=11'),
    '~>': expand('c8 out=3, c2 out=6, g out=2, p out=15'),

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
    '~<': expand('a8=10,a4=16,a2=18,a1=21, b8=9,b4=11,b2=19,b1=20, s8=13,s4=15,s2=17,s1=14, boole=23, c in=22'),
    '~>': expand('f8=6,f4=7,f2=3,f1=2, cg=4, cp=8, c out=5'),

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
    '~<': expand('a1=5,a2=6,a3=7, b1=9,b2=10,b3=11'),
    '~>': expand('qa1=2,qa2=3,qa3=4, qb1=12,qb2=13,qb3=14'),

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
    '~<': expand('in=1'),
    '~>': expand('out=7'),

    fn({i}) {
      return {
        out: i.in,              // XXX needs to be actually delayed?
      };
    },

    init() {},
  },
};


if (require.main === module)
  console.log("logic:", require('util').inspect(logic, {depth: 9, color: true}));

module.exports = logic;
