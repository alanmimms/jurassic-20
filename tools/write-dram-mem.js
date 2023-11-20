'use strict';
const DRAM = require('./dram');

// Source listing bits are [0:23] laid out as
// * A[0:2]=3
// * B[3:5]=3
// * X1[6:10]=5   UNUSED
// * P[11]=1
// * X2[12]=1     UNUSED
// * J[13:23]=11
//
// We need to pack this into the DRAM memory we actually store in the
// FPGA. In our output COE data, delete bits between B and P, between
// P and J, and J[0,5,6].
//
//     FIELD   IMAGE  COUNT
//       A      0:2     3
//       B      3:5     3
//       P       6      1
//    J[1:4]    7:10    4
//    J[7:10]  11:14    4
//                   ------
//                     15
module.exports.write = () => DRAM.map(w => {
  const inN = 24;               // Input word width
  const jN = 11;                // Input J word width
  const outN = 15;              // Output word width
  const a = fieldExtract(w, 0, 2, inN);
  const b = fieldExtract(w, 3, 5, inN);
  const p = fieldExtract(w, 11, 11, inN);
  const j = fieldExtract(w, 14, 23, inN);
  const jHi = fieldExtract(j, 1, 4, jN);
  const jLo = fieldExtract(j, 7, 10, jN);

  // Now build up a new word of 15 bits with all of our extracted
  // fields side by side with no gaps.
  w = fieldInsert(0n, a, 0, 2, outN);
  w = fieldInsert(w, b, 3, 5, outN);
  w = fieldInsert(w, p, 6, 6, outN);
  w = fieldInsert(w, jHi, 7, 10, outN);
  w = fieldInsert(w, jLo, 11, 14, outN);
  return w.toString(16).padStart(Math.floor((outN + 3)/4), '0');
}).join('\n');


// Stolen from kl10-microcode project util.js.
// Return BigInt bit mask for PDP bit numbering bit `n` in word of
// width `w`.
function maskForBit(n, w = 36) {
  n = Number(n);
  w = Number(w);
  return 1n << shiftForBit(n, w);
}
module.exports.maskForBit = maskForBit;


// In a PDP10 word of `w` bits, return the shift right count to get
// bit #n into LSB.
function shiftForBit(n, w = 36) {
  n = Number(n);
  w = Number(w);
  return BigInt(w - 1 - n);
}
module.exports.shiftForBit = shiftForBit;


// Return a BigInt mask for PDP10 numbered bit positions within `w` bit word
// of `s`..`e`. 
function fieldMask(s, e, w = 36) {
  s = Number(s);
  e = Number(e);
  w = Number(w);
  const sMask = (maskForBit(s, w) << 1n) - 1n;
  const eMask = maskForBit(e, w) - 1n;
  return sMask - eMask;
}
module.exports.fieldMask = fieldMask;


// Insert into BigInt `v` whose full width is `w` bits the value `n`
// at PDP10 numbered bit positions within `v` of `s`..`e`. Returns
// BigInt.
function fieldInsert(v, n, s, e, w = 36) {
  v = BigInt(v);
  n = BigInt(n);
  s = Number(s);
  e = Number(e);
  w = Number(w);
  return v & ~fieldMask(s, e, w) | (n << shiftForBit(e, w));
}
module.exports.fieldInsert = fieldInsert;


// Return BigInt extracted from BigInt `v` whose full width is `w`
// bits the PDP10 numbered bitfield `s`..`e`.
function fieldExtract(v, s, e, w = 36) {
  v = BigInt(v);
  s = Number(s);
  e = Number(e);
  w = Number(w);
  return (v & fieldMask(s, e, w)) >> shiftForBit(e, w);
}
module.exports.fieldExtract = fieldExtract;
