'use strict'

const colorBrewer = require('colorbrewer');
const Color = require('color');
const schemeName = process.argv[2] || 'Greens';

console.warn(`Color scheme='${schemeName}'.`);

const scheme = colorBrewer[schemeName];
const maxIndex = Object.keys(scheme)
      .reduce((prev, cur) => +cur > prev ? +cur : prev, 
              0);

for (let k = 0; k <= maxIndex; ++k) {
  
  if (scheme[k]) {
    const rgbs = scheme[k].map(hex => '{' + Color(hex).rgb().array().join(',') + '}');
    console.log(`/* ${k} */ {${rgbs.join(',')}},`);
  } else {
    console.log(`/* ${k} */ {0},`);
  }
}
