'use strict';
const CRAM = require('./cram');

module.exports.write = () => CRAM.map(w => w.toString(16).padStart(21, '0')).join('\n');
