'use strict';

const COMPILE = require('./compile');

const nets = COMPILE.compile({src: 'kl10pv.backplane'});

test('Has KL10 backplane', () => {
  const found1 = nets.some(net => net.bp.name === 'KL10PV');
  expect(found1).toBe(true);
});
