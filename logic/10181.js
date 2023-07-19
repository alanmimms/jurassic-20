'use strict';

const symbolic = true;


const ui = require('util').inspect;


function or(...a) {
  return '(' + a.join(' | ') + ')';
}


function and(...a) {
  return '(' + a.join(' & ') + ')';
}


function nor(...a) {
  return not(or(...a));
}


function xor(...a) {
  return '(' + a.join(' ^ ') + ')';
}


function nxor(...a) {
  return not(xor(...a));
}


function not(x) {
  return `~(${x})`;
}


function bitExplode(x) {

  if (symbolic) {
    return x;
  } else {
    return x.split('');
  }
}


function bitJoin(x) {

  if (symbolic) {
    return x;
  } else {
    return x.join('');
  }
}


// Return g (upper) and p (lower) outputs.
function doCGbit(a, b, s0, s1, s2, s3) {
//const g = nor(nor(s3, b, a), nor(s2, a, not(b)));
//const p = nor(nor(s1, not(b)), nor(s0, b), not(a));
  const g = and(or(s3, b, a), or(s2, a, not(b)));
  const p = and(or(s1, not(b)), or(s0, b), a);
  return [g, p];
}


function alu({a, b, s, m, c0}) {
  const [a3, a2, a1, a0] = bitExplode(a);
  const [b3, b2, b1, b0] = bitExplode(b);
  const [s3, s2, s1, s0] = bitExplode(s);

  const [g0, p0] = doCGbit(a0, b0, s0, s1, s2, s3);
  const f0 = nxor(nor(m, c0),
                  xor(g0, p0));

  const [g1, p1] = doCGbit(a1, b1, s0, s1, s2, s3);
  const f1 = nxor(or(nor(m, g0),
                     nor(m, p0, c0)),
                  xor(g1, p1));

  const [g2, p2] = doCGbit(a2, b2, s0, s1, s2, s3);
  const f2 = nxor(or(nor(m, g1),
                     nor(m, p1, g0),
                     nor(m, p1, p0, c0)),
                  xor(g2, p2));

  const [g3, p3] = doCGbit(a3, b3, s0, s1, s2, s3);
  const f3 = nxor(or(nor(m, g2),
                     nor(m, p2, g1),
                     nor(m, p2, p1, g0),
                     nor(m, p2, p1, p0, c0)),
                  xor(g3, p3));

  const p = or(p3, p2, p1, p0);
  const gc = or(not(g3),
                nor(p3, g2), 
                nor(p3, p2, g1), 
                nor(p3, p2, p1, g0));
  const g = not(gc);
  const c4 = or(gc, nor(p3, p2, p1, p0, c0));

  const f = bitJoin(f3, f2, f1, f0);

  return {f, g, p, c4};
}
  

function truthTable() {
  const pad = x => x.toString().padLeft(3);
  const bits = x => (x | 0x80).toString(2).slice(-4);


  for (let m = 0; m < 2; ++m) {

    for (let s = 0; s < 16; ++s) {

      for (let b = 0; b < 16; ++b) {

        for (let a = 0; a < 16; ++a) {
          const c0 = 0;
          const f = alu({a: bits(a), b: bits(b), s: bits(s), m: bits(m), c0: bits(c0)});

          console.log(pad(s), pad(m), pad(a), pad(b), pad(f));
        }
      }
    }
  }
}


const {f, p, g, c4} = alu({
//  a: ['a3', 'a2', 'a1', 'a0'],
//  b: ['b3', 'b2', 'b1', 'b0'],
//  s: ['s3', 's2', 's1', 's0'],
  a: ['A', 'B', 'C', 'D'],
  b: ['E', 'F', 'G', 'H'],
  s: ['S', 'T', 'U', 'V'],
  m: 'm',
  c0: 'z'});

console.log('f=', f, '\n');
console.log('p=', p, '\n');
console.log('g=', g, '\n');
console.log('c4=', c4, '\n');

// From dcode.fr/boolean-expressions-calculator
// in = (v nor b nor a) nor (u nor a nor !b)
// g0 = a OR (b AND u) OR (NOT b AND v)
// From 74181
// in = (v and b and a) or (u and a and !b)
// g0 = (a AND b AND v) OR (a AND NOT b AND u)
