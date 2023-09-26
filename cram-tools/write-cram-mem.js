'use strict';
const CRAM = require('./cram');

CRAM.forEach(w => console.log(w.toString(16).padStart(21, '0')));

