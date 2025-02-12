<?php
namespace JsonLogicCompat\Reporting;

class TestSummary {
    private array $resultsBySuite = [];
    private array $totals = [];
    private array $timestamps = [];
    private array $phpVersions = [];

    public function addResult(string $suiteName, string $engine, int $passed, int $total): void {
        // Initialize suite results if not exists
        if (!isset($this->resultsBySuite[$suiteName])) {
            $this->resultsBySuite[$suiteName] = [];
        }

        // Add suite result
        $stats = [
            'passed' => $passed,
            'total' => $total,
            'success_rate' => $total > 0 ? ($passed / $total * 100) : 0
        ];
        
        $this->resultsBySuite[$suiteName][$engine] = $stats;

        // Update totals
        if (!isset($this->totals[$engine])) {
            $this->totals[$engine] = ['passed' => 0, 'total' => 0, 'success_rate' => 0];
        }
        
        $this->totals[$engine]['passed'] += $passed;
        $this->totals[$engine]['total'] += $total;
        
        $totalStats = &$this->totals[$engine];
        $totalStats['success_rate'] = $totalStats['total'] > 0 
            ? ($totalStats['passed'] / $totalStats['total'] * 100) 
            : 0;
    }

    public function saveJson(string $filename): void {
        // Add current run info
        $this->timestamps[] = date('c');
        $this->phpVersions[] = PHP_VERSION;

        $result = [
            'test_suites' => $this->resultsBySuite,
            'totals' => $this->totals,
            'timestamp' => $this->timestamps,
            'php_version' => $this->phpVersions
        ];

        $jsonData = json_encode($result, JSON_PRETTY_PRINT);
        file_put_contents($filename, $jsonData);
    }
}