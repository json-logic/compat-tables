import jsonLogicJs from 'json-logic-js';
import { LogicEngine } from 'json-logic-engine';

export class TestRunner {
    constructor(engine) {
        this.engine = engine;
        this.jsonLogicEngine = new LogicEngine();
    }

    async runTest(testCase) {
        try {
            const result = await this.applyRule(testCase.logic, testCase.data);
            if (testCase.expectedError) {
                return false;
            }

            const success = this.compareValues(result, testCase.expectedValue);
            if (!success) {
                console.log('Result:', result);
            }
            return success;
        } catch (error) {
            if (!testCase.expectedError) {
                return false;
            }
            return this.compareErrors(error.message, testCase.expectedError);
        }
    }

    async applyRule(rule, data) {
        switch (this.engine) {
            case 'json-logic-js':
                return jsonLogicJs.apply(rule, data);
            case 'json-logic-engine':
                return this.jsonLogicEngine.run(rule, data);
            default:
                throw new Error(`Unknown engine: ${this.engine}`);
        }
    }

    compareValues(got, expected) {
        // Handle null comparisons
        if (expected === null) {
            return got === null || got === false || got === 0 || got === '' || 
                   (Array.isArray(got) && got.length === 0);
        }

        // Handle NaN
        if (Number.isNaN(got) && Number.isNaN(expected)) {
            return true;
        }

        // Handle floating point comparisons
        if (typeof got === 'number' && typeof expected === 'number') {
            return Math.abs(got - expected) < 1e-10;
        }

        // Handle array comparisons
        if (Array.isArray(got) && Array.isArray(expected)) {
            if (got.length !== expected.length) {
                return false;
            }
            return got.every((value, index) => this.compareValues(value, expected[index]));
        }

        // Default strict comparison
        return got === expected;
    }

    compareErrors(got, expected) {
        if (typeof expected !== 'object') {
            return false;
        }
        
        const expectedType = expected.type?.toLowerCase() ?? '';
        const expectedMessage = expected.message?.toLowerCase() ?? '';
        
        return (!expectedType || got.toLowerCase().includes(expectedType)) &&
               (!expectedMessage || got.toLowerCase().includes(expectedMessage));
    }
}