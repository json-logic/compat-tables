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
            if (Number.isNaN(error)) 
                error = { type: 'NaN' }
            else if (error.message) 
                error = { type: error.message }

            if (JSON.stringify(error) === JSON.stringify(testCase.expectedError) ) {
                return true;
            }

            const success = this.compareErrors(error.type, testCase.expectedError);
            if (!success) {
                console.log('Result:', error);
            }
            return success;
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

        // Handle object comparisons
        if (typeof got === 'object' && typeof expected === 'object') {
            if (got === null || expected === null) {
                return got === expected;
            }
            const gotKeys = Object.keys(got);
            const expectedKeys = Object.keys(expected);
            if (gotKeys.length !== expectedKeys.length) {
                return false;
            }
            return gotKeys.every(key => 
                expectedKeys.includes(key) && 
                this.compareValues(got[key], expected[key])
            );
        }

        // Default strict comparison
        return got === expected;
    }

    compareErrors(got, expected) {
        console.log('compareErrors: got:', got);
        console.log('expected:', expected.type);

        if (!got || typeof expected !== 'object') {
            return false;
        }

        if (expected.type === got || expected === got) {
            return true;
        }
        
        const gotLower = got.toLowerCase();
        const expectedType = expected?.type?.toLowerCase() ?? '';
        const expectedMessage = expected?.message?.toLowerCase() ?? '';
        
        return (!expectedType || gotLower.includes(expectedType)) &&
               (!expectedMessage || gotLower.includes(expectedMessage));
    }
}