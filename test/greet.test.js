const test = require('node:test');
const assert = require('node:assert');
const { greet } = require('../site/greet.js');

test('greet says hello to the given name', () => {
  assert.strictEqual(greet('Asha'), 'Hello, Asha! Welcome to DevOps.');
});

test('greet always mentions DevOps', () => {
  assert.ok(greet('anyone').includes('DevOps'));
});
