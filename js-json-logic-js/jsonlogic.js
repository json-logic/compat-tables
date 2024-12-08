const { Before, Given, When, Then, After } = require('@cucumber/cucumber');
const jsonLogic = require('json-logic-js');
const assert = require('assert');

class JSONLogicWorld {
    constructor() {
        this.rule = null;
        this.data = null;
        this.result = null;
    }
}

let totalExecutionTime = 0;

Before(function() {
    this.world = new JSONLogicWorld();
});

Given('the rule {string}', function(ruleStr) {
    const cleanStr = ruleStr.replace(/\\"/g, '"');
    try {
        this.world.rule = JSON.parse(cleanStr);
    } catch (e) {
        this.world.rule = cleanStr;
        // throw new Error(`Failed to parse rule JSON: ${e}\nInput was: ${cleanStr}`);
    }
});

Given('the data {string}', function(dataStr) {
    const cleanStr = dataStr.replace(/\\"/g, '"');
    try {
        this.world.data = JSON.parse(cleanStr);
    } catch (e) {
        this.world.data = cleanStr;
        // throw new Error(`Failed to parse data JSON: ${e}\nInput was: ${cleanStr}`);
    }
});

When('I evaluate the rule', function() {
    const start = process.hrtime();
    this.world.result = jsonLogic.apply(
        this.world.rule,
        this.world.data || null
    );
    const [seconds, nanoseconds] = process.hrtime(start);
    this.executionTime = seconds * 1e9 + nanoseconds;
    totalExecutionTime += this.executionTime;
});

Then('the result should be {string}', function(expected) {
    let expectedValue;
    const cleanStr = expected.replace(/\\"/g, '"');
    try {
        expectedValue = JSON.parse(cleanStr);
    } catch (e) {
        throw new Error(`Failed to parse expected data JSON: ${e}\nInput was: ${cleanStr}`);
    }

    const actualJson = JSON.stringify(this.world.result);
    const expectedJson = JSON.stringify(expectedValue);
    
    assert.strictEqual(
        actualJson,
        expectedJson,
        `Expected ${expectedJson} but got ${actualJson}`
    );
});
