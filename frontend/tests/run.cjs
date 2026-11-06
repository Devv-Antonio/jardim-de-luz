const assert = require('node:assert/strict');
const fs = require('node:fs');
const vm = require('node:vm');
const sandbox = { console, setTimeout, clearTimeout };
vm.runInNewContext(fs.readFileSync('elm-stuff/checks.js', 'utf8'), sandbox);
const app = sandbox.Elm.Checks.init();
const timer = setTimeout(() => { console.error('Elm não respondeu.'); process.exit(1); }, 5000);
app.ports.report.subscribe(errors => {
  clearTimeout(timer);
  assert.equal(errors.length, 0, errors.join('\n'));
  console.log('17 verificações Elm passaram.');
});
