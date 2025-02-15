export class TestCase {
    constructor(rule, data, expectedValue, expectedError = null) {
        this.logic = rule;
        this.data = data;
        this.expectedValue = expectedValue;
        this.expectedError = expectedError;
    }

    static fromJson(json) {
        return new TestCase(
            json.rule,
            json.data,
            json.result,
            json.error
        );
    }
}