import fs from 'fs/promises';
import path from 'path';
import { TestCase } from './test/TestCase.js';
import { TestRunner } from './engines/TestRunner.js';
import { TestSummary } from './reporting/TestSummary.js';

async function loadTestSuites() {
    const indexPath = path.join(process.cwd(), '..', 'suites', 'index.json');
    const files = JSON.parse(await fs.readFile(indexPath, 'utf8'));
    
    const suites = {};
    const suitesDir = path.join(process.cwd(), '..', 'suites');
    
    for (const file of files) {
        const filePath = path.join(suitesDir, file);
        const suite = JSON.parse(await fs.readFile(filePath, 'utf8'));
        suites[file] = suite;
    }
    
    return suites;
}

async function runEngineSuite(engine, suite) {
    const runner = new TestRunner(engine);
    let passed = 0;
    let total = 0;

    for (const testCase of suite) {
        if (typeof testCase !== 'object') continue;
        
        total++;
        const case_ = TestCase.fromJson(testCase);
        
        if (await runner.runTest(case_)) {
            passed++;
        } else {
            console.log('Failed test case:', case_);
            
        }
    }

    if (total > 0) {
        const successRate = (passed / total * 100);
        console.log(`\nResults: ${passed}/${total} passed (${successRate.toFixed(2)}%)`);
    }

    return [passed, total];
}

async function main() {
    try {
        const suites = await loadTestSuites();
        console.log(`Successfully loaded ${Object.keys(suites).length} test suites`);

        const summary = new TestSummary();
        const engines = ['json-logic-js', 'json-logic-engine'];

        for (const [name, suite] of Object.entries(suites)) {
            console.log(`\nRunning suite: ${name}`);
            
            for (const engine of engines) {
                console.log(`\nTesting engine: ${engine}`);
                const [passed, total] = await runEngineSuite(engine, suite);
                summary.addResult(name, engine, passed, total);
            }
        }

        const resultPath = path.join(process.cwd(), '..', 'results', 'javascript.json');
        await summary.saveJson(resultPath);
        console.log(`\nReport generated: ${resultPath}`);
    } catch (error) {
        console.error('Error:', error);
        process.exit(1);
    }
}

main();