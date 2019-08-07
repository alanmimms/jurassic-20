'use strict';

// Closer than this in X or Y is equivalent.
const epsilon = 10.0;

const lines = require('./corners.lines.js');
console.log(`${lines.length} lines`);

const rawLengths = [];
const rawThetas = [];

// Compute histograms
lines.forEach(line => {
  const len = Math.round(Math.sqrt((line.x1 - line.x2)**2 + (line.y1 - line.y2)**2));
  const pop = rawLengths[len] || 0;
  rawLengths[len] = pop + 1;
  const th = Math.round(radToDeg(Math.atan2(line.y2 - line.y1, line.x2 - line.x1)));
  const thPop = rawThetas[th] || 0;
  rawThetas[th] = thPop + 1;
});

const popSort = (a, b) => a.pop - b.pop;

const lengthHist = rawLengths
      .filter((pop, len) => pop)
      .map((pop, len) => ({pop, len}))
      .sort(popSort);

lengthHist.forEach(h => console.log(h));

const thHist = rawThetas
      .filter((pop, th) => pop)
      .map((pop, th) => ({pop, th}))
      .sort(popSort);

const hOrVHist = thHist.filter(isHorV);
hOrVHist.forEach(h => console.log(h));
const hOrVPop = hOrVHist.reduce((acc, cur) => acc + cur.pop, 0);
console.log(`${hOrVPop} of ${lines.length} or ${hOrVPop / lines.length * 100}%`);


function radToDeg(rad) {
  return rad * 180.0 / Math.PI;
}


function isHorV(h) {
  const thEpsilon = 5.0;
  const th = h.th;
  return th < thEpsilon ||
    Math.abs(th - 90) < thEpsilon ||
    Math.abs(th - 180) < thEpsilon ||
    Math.abs(th - 270) < thEpsilon;
}
