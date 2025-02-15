<?php
require_once __DIR__ . '/vendor/autoload.php';
require_once __DIR__ . '/engines/TestRunner.php';
require_once __DIR__ . '/test/TestCase.php';
require_once __DIR__ . '/reporting/TestSummary.php';

use JsonLogic\JsonLogic;
use JsonLogicCompat\Test\TestCase;
use JsonLogicCompat\Engines\TestRunner;
use JsonLogicCompat\Reporting\TestSummary;

// Load test suites
function loadTestSuites(): array {
    $indexPath = dirname(__DIR__) . '/suites/index.json';
    if (!file_exists($indexPath)) {
        throw new RuntimeException("Index file not found: $indexPath");
    }

    $files = json_decode(file_get_contents($indexPath), true);
    if (json_last_error() !== JSON_ERROR_NONE) {
        throw new RuntimeException("Error parsing index.json: " . json_last_error_msg());
    }

    $suites = [];
    $suitesDir = dirname(__DIR__) . '/suites';
    
    foreach ($files as $file) {
        $filePath = $suitesDir . '/' . $file;
        if (!file_exists($filePath)) {
            throw new RuntimeException("Suite file not found: $filePath");
        }

        $suite = json_decode(file_get_contents($filePath), true);
        if (json_last_error() !== JSON_ERROR_NONE) {
            throw new RuntimeException("Error parsing $file: " . json_last_error_msg());
        }

        $suites[$file] = $suite;
    }
    
    return $suites;
}

// Run tests for each engine
function runEngineSuite(string $engine, array $suite): array {
    $runner = new TestRunner($engine);
    $passed = 0;
    $total = 0;

    foreach ($suite as $testCase) {
        if (!is_array($testCase)) {
            continue;
        }
        
        $total++;
        $case = TestCase::fromArray($testCase);
        
        if ($runner->runTest($case)) {
            $passed++;
        }
    }

    // Add summary for this suite
    if ($total > 0) {
        $successRate = ($passed / $total) * 100;
        echo sprintf("\nResults: %d/%d passed (%.2f%%)\n", $passed, $total, $successRate);
    }

    return [$passed, $total];
}

// Main execution
try {
    $suites = loadTestSuites();
    echo sprintf("Successfully loaded %d test suites\n", count($suites));

    $summary = new TestSummary();

    foreach ($suites as $name => $suite) {
        echo "\nRunning suite: $name\n";
        [$passed, $total] = runEngineSuite('jwadhams', $suite);
        $summary->addResult($name, 'jwadhams', $passed, $total);
    }

    $summary->saveJson(dirname(__DIR__) . '/results/php.json');
} catch (Exception $e) {
    echo "Error: " . $e->getMessage() . "\n";
    exit(1);
}