'use strict';

const {cramFields} = require('./fields-model');
const unusedCRAMFields = `U0,U21,U23,U42,U45,U48,U51,U73`.split(/,/);

const fields = Object.entries(cramFields)
      .filter(([name, {s, e}]) => s)
      .filter(([name]) => !unusedCRAMFields.includes(name));

// Dump module header content
fields
  .forEach(([name, {s, e}]) => {
    name = fixName(name);
    console.log(`output [${e - s + 1}:0] ${name},`);
  });


// Dump assign statements to build fields out of CRAMdata
fields
  .forEach(([name, {s, e}]) => {
    name = fixName(name);
    console.log(`assign ${name} = CRAMdata[${s}:${e}];`);
  });


function fixName(name) {
  name = name.replace(/[- /.]/g, '_');
  name = name.replace(/#/g, 'magic');
  return name;
}
