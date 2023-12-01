"use strict";

const fs = require('fs');
const util = require('util');


var buf = Buffer.alloc(256);

function get36(ofs) {
  let byteOfs = Math.floor(ofs * 5);
  if (fs.readSync(0, buf, 0, 16, byteOfs) <= 0) return null;
  return buf.readUInt32BE(0) * 16 + (buf.readUInt8(4) & 0x0F);
}


function to8(w) {
  return w.toString(8);
}

const lhMult =   	 0o000001000000;
const lhMask =   	 0o777777000000;
const rhMask =   	 0o000000777777;

const getLH = w => Math.floor(w / lhMult);
const getRH = w => w % lhMult;

// Return optionally zero-padded halfword as octal.
const half = hw => to8(hw).padStart(6, '0');


// Return string canonical representation of octal halfwords separated
// by double commas with zero padding on left if 'padding'.
const halves = w =>
  (w < 0o1000)
    ? half(w)
    : `${half(getLH(w))},,${half(getRH(w))}`;


let w;

for (let k = 0; (w = get36(k)) != null; ++k) {
  console.log(`${half(k)}: ${halves(w)}`);
}

