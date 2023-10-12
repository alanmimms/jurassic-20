'use strict';

// This builds an object whose properties are the chip types - e.g., '10181' for an ALU.
// These properties have object values of the form
// {
//   desc: 'short description',
//   '~<': {...},
//   '~>': {...},
// }
// 
// The `~<` and `~>` properties are objects indexed both by pin number
// string and by pin name.
//
// THEREFORE, PIN NAMES AND NUMBERS MUST BE UNIQUE IN A GIVEN CHIP TYPE.
//
// To generate the SystemVerilog code for these chip instances, the
// pin names used here must match the SV implementations in
// `./rtl/logic/*.sv`.

function expand(s) {
  const split = s.split(/,\s*/);
  const pins = split.map(el => {
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
  });

  return pins.reduce((o, e) => {
    o[e.pin] = e;
    o[e.name] = e;
    return o;
  }, {});
}


const logic = {
  '10101': {
    desc: '4xor/nor',
    '~<': expand('a1=4, b1=7, c1=10, d1=13, abcd2=12'),
    '~>': expand('nqa=2,qa=5, nqb=3,qb=6, nqc=14,qc=11, nqd=15,qd=9'),
  },

  '10103': {
    desc: '4xor',
    '~<': expand('a1=4,a2=5, b1=6,b2=7, c1=12,c2=13, d1=10,d2=11'),
    '~>': expand('qa=2, qb=3, qc=15,nqc=9, qd=14'),
  },

  '10104': {
    desc: '4xand', 
    '~<': expand('a1=4,a2=5, b1=6,b2=7, c1=10,c2=11, d1=12,d2=13'),
    '~>': expand('qa=2, qb=3, qc=14, qd=15,nqd=9'),
  },

  '10105': {
    desc: '2-3-2 or/nor',
    '~<': expand('a1=4,a2=5, b1=9,b2=10,b3=11, c1=13,c2=12'),
    '~>': expand('nqa=3,qa=2, nqb=6,qb=7, nqc=14,qc=15'),
  },

  '10107': {
    desc: 'triple xor/xnor',
    '~<': expand('a1=4,a2=5, b1=9,b2=7, c1=14,c2=15'),
    '~>': expand('nqa=2,qa=3, nqb=11,qb=10, nqc=12,qc=13'),
  },

  '10109': {
    desc: '4/5 or/nor',
    '~<': expand('a1=4,a2=5,a3=6,a4=7, b1=9,b2=10,b3=11,b4=12,b5=13'),
    '~>': expand('nqa=3,qa=2, nqb=14,qb=15'),
  },

  '10110': {
    desc: '2x or buffer',
    '~<': expand('a1=5,a2=6,a3=7, b1=9,b2=10,b3=11'),
    '~>': expand('qa1=2,qa2=3,qa3=4, qb1=12,qb2=13,qb3=14'),
  },

  '10113': {
    desc: '4x xor buffer',
    '~<': expand('a1=4,a2=5, b1=6,b2=7, c1=10,c2=11, d1=12,d2=13, ne=9'),
    '~>': expand('qa=2, qb=3, qc=14, qd=15'),
  },

  '10117': {
    desc: '2x2-3 or-and/or-and',
    '~<': expand('a1=4,a2=5, b1=6,b2=7, b3c3=9, c1=10,c2=11, d1=12,d2=13'),
    '~>': expand('nqa=3,qa=2, nqb=14,qb=15'),
  },

  '10118': {
    desc: '2x3 or-and',
    '~<': expand('a1=3,a2=4,a3=5, b1=6,b2=7, c1=10,c2=11, d1=12,d2=13,d3=14, b3c3=9'),
    '~>': expand('qab=2, qcd=15'),
  },

  '10121': {
    desc: '4-wide or-and/or-and',
    '~<': expand('a1=4,a2=5,a3=6, b1=7,b2=9, c1=11,c2=12, d1=13,d2=14,d3=15, b3c3=10'),
    '~>': expand('nqa=3,qa=2'),
  },

  '10131': {
    desc: 'dual d ms ff',
    '~<': expand('da=7,cea=6,sa=5,ra=4, db=10,ceb=11,sb=12,rb=13, clk=9'),
    '~>': expand('qa=2,nqa=3, qb=15,nqb=14'),
  },

  '10136': {
    desc: 'binary counter',
    '~<': expand('d8=5,d4=6,d2=11,d1=12,nCryIn=10, sel2=7,sel1=9,clk=13'),
    '~>': expand('q8=3,q4=2,q2=15,q1=14,nCryOut=4'),
  },

  '10141': {
    desc: 'shift reg',
    '~<': expand('shft0in=13, d0=12,d1=11,d2=9,d3=6, shft3in=5, op1=10,op2=7, clk=4'),
    '~>': expand('q0=14,q1=15,q2=2,q3=3'),
  },

  '10144': {
    desc: '256x1 ram',
    '~<': expand('a0=1,a1=2,a2=3,a3=4,a4=9,a5=10,a6=11,a7=12, nen1=5,nen2=6,nen3=7, nwrite=14, d=13'),
    '~>': expand('q=15'),
  },

  '10145': {
    desc: '16x4 ram',
    '~<': expand('d0=5,d1=4,d2=11,d3=12, a0=10,a1=9,a2=7,a3=6, nen=3, nwrite=13'),
    '~>': expand('q0=2,q1=1,q2=15,q3=14'),
  },

  '10147': {
    desc: '128x1 ram',
    '~<': expand('a0=4,a1=3,a2=2,a3=5,a4=6,a5=7,a6=10, nen1=13,nen2=14, nwrite=12, d=11'),
    '~>': expand('q=15'),
  },

  '10415a': {
    desc: '1024x1 ram',
    '~<': expand('a0=2,a1=3,a2=4,a3=5,a4=6,a5=7,a6=9,a7=10,a8=11,a9=12, nen=14, nwrite=13, d=15'),
    '~>': expand('q=1'),
  },

  '10158': {
    desc: '4x2 mix',
    '~<': expand('d00=5,d01=6, d10=3,d11=4, d20=12,d21=13, d30=10,d31=11, sel=9'),
    '~>': expand('b0=1,b1=2,b2=15,b3=14'),
  },

  '10160': {
    desc: 'parity',
    '~<': expand('d0=3,d1=4,d2=5,d3=6,d4=7,d5=9,d6=10,d7=11,d8=12,d9=13,d10=14,d11=15'),
    '~>': expand('odd=2'),
  },

  '10161': {
    desc: 'decoder active low',
    '~<': expand('sel4=14,sel2=9,sel1=7, nen1=15,nen2=2'),
    '~>': expand('nq0=6,nq1=5,nq2=4,nq3=3,nq4=13,nq5=12,nq6=11,nq7=10'),
  },

  '10162': {
    desc: 'decoder',
    '~<': expand('sel4=14,sel2=9,sel1=7, nen1=15,nen2=2'),
    '~>': expand('q0=6,q1=5,q2=4,q3=3,q4=13,q5=12,q6=11,q7=10'),
  },

  '10164': {
    desc: '8 mix',
    '~<': expand('d0=6,d1=5,d2=4,d3=3,d4=11,d5=12,d6=13,d7=14, sel4=10,sel2=9,sel1=7, nen=2'),
    '~>': expand('b=15'),
  },

  '10165': {
    desc: 'pri enc',
    '~<': expand('d0=5,d1=7,d2=13,d3=10,d4=11,d5=12,d6=9,d7=6, hold=4'),
    '~>': expand('any=14, q4=15,q2=2,q1=3'),
  },

  '10173': {
    desc: '2x4 mix latch',
    '~<': expand('d00=5,d01=6, d10=3,d11=4, d20=12,d21=13, d30=10,d31=11, sel=9, nen=7'),
    '~>': expand('b0=1,b1=2,b2=15,b3=14'),
  },

  '10174': {
    desc: '2x4 mix',
    '~<': expand('d00=3,d01=5,d02=4,d03=6, d10=13,d11=11,d12=12,d13=10, sel2=9,sel1=7, nen=14'),
    '~>': expand('b0=2,b1=15'),
  },

  '10176': {
    desc: '6xdff',
    '~<': expand('d0=5,d1=6,d2=7,d3=10,d4=11,d5=12, clk=9'),
    '~>': expand('q0=2,q1=3,q2=4,q3=13,q4=14,q5=15'),
  },

  '10179': {
    desc: 'carry skipper',
    '~<': expand('g8=5,p8=13,g4=9,p4=12, g2=7,p2=10,g1=4,p1=14, cin=11'),
    '~>': expand('c8out=3, c2out=6, gout=2, pout=15'),
  },

  '10181': {
    desc: 'alu',
    '~<': expand('a8=10,a4=16,a2=18,a1=21, b8=9,b4=11,b2=19,b1=20, s8=13,s4=15,s2=17,s1=14, boole=23, cin=22'),
    '~>': expand('f8=6,f4=7,f2=3,f1=2, cg=4,cp=8, cout=5'),
  },

  '10210': {
    desc: '2x3 or',
    '~<': expand('a1=5,a2=6,a3=7, b1=9,b2=10,b3=11'),
    '~>': expand('qa1=2,qa2=3,qa3=4, qb1=12,qb2=13,qb3=14'),
  },

  'seq': {
    desc: 'sequencer for delays',
    '~<': expand('reset=10, clk=9'),
    '~>': expand('q7=8, q6=7, q5=6, q4=5, q3=4, q2=3, q1=2, q0=1'),
  },

  'delayN': {
    desc: 'delay a signal N clk edges',
    '~<': expand('clk=1, trigger=2'),
    '~>': expand('q=3'),
  },

  'delayNinverted': {
    desc: 'delay an active-low signal N clk edges',
    '~<': expand('clk=1, ntrigger=2'),
    '~>': expand('nq=3'),
  },

  'delay1': {
    desc: 'delay a signal 1 clk edges',
    '~<': expand('clk=1, trigger=2'),
    '~>': expand('q=3'),
  },

  'delay2': {
    desc: 'delay a signal 2 clk edges',
    '~<': expand('clk=1, trigger=2'),
    '~>': expand('q=3'),
  },

  'delay3': {
    desc: 'delay a signal 3 clk edges',
    '~<': expand('clk=1, trigger=2'),
    '~>': expand('q=3'),
  },

  'delay-line': {
    desc: 'delay buffer',
    '~<': expand('in=1'),
    '~>': expand('out=2'),
  },

  'tapped-delay-20-2': {
    desc: 'tapped delay 20ns 2ns/tap',
    '~<': expand('in=3'),
    '~>': expand('t1=4,t2=5,t3=6,t4=7,t5=8,t6=9,t7=10,t8=11,t9=12, out=13'),
  },

  'tapped-delay-50-10': {
    desc: 'tapped delay 50ns 10ns/tap',
    '~<': expand('in=1'),
    '~>': expand('t1=2,t2=3,t3=5,t4=6, out=7'),
  },

  'oscillator': {
    desc: 'clock oscillator',
    '~<': expand('clk=1'),
    '~>': expand('out=2'),
  },

  'wire': {
    desc: 'just a wire',
    '~<': expand('b=1'),
    '~>': expand('q=2'),
  },

  pinToName(type, pinNumString, dir) {

    if (type == undefined || pinNumString == undefined || dir == undefined ||
	!logic[type][dir][pinNumString])
    {
      console.error(`pinToName: type='${type}' pinNumString=${pinNumString} dir='${dir}'`);
    }

    return logic[type][dir][pinNumString].name;
  },
};


if (require.main === module)
  console.log("logic:", require('util').inspect(logic, {depth: 9, color: true}));

module.exports = logic;
