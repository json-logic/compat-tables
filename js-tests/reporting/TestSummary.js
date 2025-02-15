import fs from 'fs/promises';
import path from 'path';

export class TestSummary {
    constructor() {
        this.resultsBySuite = {};
        this.totals = {};
    }

    addResult(suiteName, engine, passed, total) {
        // Initialize suite results if not exists
        if (!this.resultsBySuite[suiteName]) {
            this.resultsBySuite[suiteName] = {};
        }

        // Add suite result
        const stats = {
            passed,
            total,
            success_rate: total > 0 ? (passed / total * 100) : 0
        };
        
        this.resultsBySuite[suiteName][engine] = stats;

        // Update totals
        if (!this.totals[engine]) {
            this.totals[engine] = { passed: 0, total: 0, success_rate: 0 };
        }
        
        this.totals[engine].passed += passed;
        this.totals[engine].total += total;
        this.totals[engine].success_rate = 
            this.totals[engine].total > 0 
                ? (this.totals[engine].passed / this.totals[engine].total * 100) 
                : 0;
    }

    async saveJson(filename) {
        const result = {
            test_suites: this.resultsBySuite,
            totals: this.totals,
            timestamp: new Date().toISOString()
        };

        await fs.writeFile(filename, JSON.stringify(result, null, 2));
    }
}