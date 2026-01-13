const fs = require('fs');
const path = require('path');
const assert = require('assert');
const YAML = require('yaml');
const {
  timeago,
  duration,
  parse_duration,
  human_date,
  date_range
} = require('./index');

function loadTests() {
  const yamlPath = path.join(__dirname,  'tests.yaml');
  const content = fs.readFileSync(yamlPath, 'utf8');
  return YAML.parse(content);
}

function runTestCase(fnName, caseData) {
  const { name } = caseData;
  const expectError = caseData.error === true;
  const input = caseData.input;
  const output = caseData.output;

  const callFunction = () => {
    switch (fnName) {
      case 'timeago':
        return timeago(input.timestamp, input.reference);
      case 'duration':
        return duration(input.seconds, input.options || {});
      case 'parse_duration':
        return parse_duration(input);
      case 'human_date':
        return human_date(input.timestamp, input.reference);
      case 'date_range':
        return date_range(input.start, input.end);
      default:
        throw new Error(`Unknown function ${fnName}`);
    }
  };

  if (expectError) {
    assert.throws(callFunction, Error, `${fnName}: ${name}`);
  } else {
    const result = callFunction();
    assert.strictEqual(result, output, `${fnName}: ${name}`);
  }
}

function main() {
  const tests = loadTests();
  const functions = ['timeago', 'duration', 'parse_duration', 'human_date', 'date_range'];
  let total = 0;
  let failed = 0;
  const failures = [];

  for (const fn of functions) {
    const cases = tests[fn] || [];
    for (const c of cases) {
      total += 1;
      try {
        runTestCase(fn, c);
      } catch (err) {
        failed += 1;
        failures.push({ fn, name: c.name, error: err.message });
      }
    }
  }

  if (failed === 0) {
    console.log(`All ${total} tests passed.`);
    return;
  }

  console.error(`${failed} of ${total} tests failed.`);
  for (const f of failures) {
    console.error(`- ${f.fn}: ${f.name} -> ${f.error}`);
  }
  process.exit(1);
}

if (require.main === module) {
  main();
}
