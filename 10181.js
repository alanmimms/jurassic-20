'use strict';

const nor = (...a) => `!(${a.join(' | ')})`;
const xor = (...a) => a.join(' ^ ');
const nxor = (...a) => `!(${a.join(' ^ ')})`;
const not = x => `!${x}`;
const or = a => a.join(' | ');


// Return x, which is the upper and y which is the lower output.
function oneBitIn(a, b, s0, s1, s2, s3) {
  const x = nor(nor(s3, b, a), nor(s2, a, not(b)));
  const y = nor(nor(s1, not(b)), nor(s0, b), not(a));
  return [x, y];
}


function bitExplode(x) {
  return x.split('');
}


function bitJoin(x) {
  return x.join('');
}


function alu({a, b, s, m, cin}) {
  const [a3, a2, a1, a0] = bitExplode(a);
  const [b3, b2, b1, b0] = bitExplode(b);
  const [s3, s2, s1, s0] = bitExplode(s);

  const [x0, y0] = oneBitIn(a0, b0, s0, s1, s2, s3);
  const f0 = nxor(nor(m, cin), xor(x0, y0));

  const [x1, y1] = oneBitIn(a1, b1, s0, s1, s2, s3);
  const f1 = nxor(or(nor(m, x0),
                     nor(m, cin, y0)),
                  xor(x1, y1));

  const [x2, y2] = oneBitIn(a2, b2, s0, s1, s2, s3);
  const f2 = nxor(or(nor(m, x1),
                     nor(m, x0, y1),
                     nor(m, cin, y0, y1)),
                  xor(x2, y2));

  const [x3, y3] = oneBitIn(a3, b3, s0, s1, s2, s3);
  const f3 = nxor(or(nor(m, x2),
                     nor(m, y2, x1),
                     nor(m, cin, y2, y1),
                     nor(m, cin, y2, y1, y0)),
                  xor(x3, y3));

  const p = or(y3, y2, y1, y0);
  const gc = or(not(x3), 
                nor(y3, x2), 
                nor(y3, y2, y1), 
                nor(y3, y2, y1, y0));
  const g = not(gc);
  const cout = or(gc, nor(y3, y2, y1, y0, cin));

  const f = bitJoin(f3, f2, f1, f0);

  return {f, g, p, cout};
}
  

function truthTable() {
  const pad = x => x.toString().padLeft(3);
  const bits = x => (x | 0x80).toString(2).slice(-4);


  for (let m = 0; m < 2; ++m) {

    for (let s = 0; s < 16; ++s) {

      for (let b = 0; b < 16; ++b) {

        for (let a = 0; a < 16; ++a) {
          const cin = 0;
          const f = alu({a: bits(a), b: bits(b), s: bits(s), m: bits(m), cin: bits(cin)});

          console.log(pad(s), pad(m), pad(a), pad(b), pad(f));
        }
      }
    }
  }
}
