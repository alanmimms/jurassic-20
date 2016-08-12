'use strict';

const assert = require('assert');
const app = require('../../../src/app');

describe('schematic service', function() {
  it('registered the schematics service', () => {
    assert.ok(app.service('schematics'));
  });
});
