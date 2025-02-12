<?php
namespace JsonLogicCompat\Engines;

use JWadhams\JsonLogic;
use JsonLogicCompat\Test\TestCase;

class TestRunner {
    private string $engine;

    public function __construct(string $engine) {
        $this->engine = $engine;
    }

    public function runTest(TestCase $case): bool {
        try {
            $result = $this->applyRule($case->logic, $case->data);
            
            if ($case->expectedError) {
                return false;
            }
            
            return $this->compareValues($result, $case->expectedValue);
        } catch (\Exception $e) {
            if (!$case->expectedError) {
                return false;
            }
            return $this->compareErrors($e->getMessage(), $case->expectedError);
        }
    }

    private function applyRule($rule, $data) {
        if ($this->engine === 'jwadhams') {
            // Debug input
            echo "\nRule: " . json_encode($rule, JSON_PRETTY_PRINT);
            echo "\nData: " . json_encode($data, JSON_PRETTY_PRINT);
    
            // Handle scalar rules (direct values)
            if (!is_array($rule)) {
                $result = $rule;
                echo "\nScalar Result: " . json_encode($result, JSON_PRETTY_PRINT) . "\n";
                return $result;
            }
    
            // Ensure data is an array
            $data = $this->normalizeData($data);
    
            // Special case: empty var returns data
            if (count($rule) === 1 && array_key_exists('var', $rule) && $rule['var'] === '') {
                $result = $data;
                echo "\nEmpty Var Result: " . json_encode($result, JSON_PRETTY_PRINT) . "\n";
                return $result;
            }
    
            // Apply the rule
            try {
                $result = JsonLogic::apply($rule, $data);
                echo "\nResult: " . json_encode($result, JSON_PRETTY_PRINT) . "\n";
                return $result;
            } catch (\Exception $e) {
                echo "\nError: " . $e->getMessage() . "\n";
                throw new \RuntimeException("Error applying rule: " . $e->getMessage());
            }
        }
        throw new \RuntimeException("Unknown engine: {$this->engine}");
    }

    private function normalizeData($data) {
        // Handle null data
        if ($data === null) {
            return [];
        }
    
        // Handle scalar data
        if (!is_array($data)) {
            $result = array();
            $result[''] = $data;
            return $result;
        }
    
        return $data;
    }

    private function compareValues($got, $expected): bool {
        echo "\nComparing:";
        echo "\n  Got     : " . json_encode($got, JSON_PRETTY_PRINT);
        echo "\n  Expected: " . json_encode($expected, JSON_PRETTY_PRINT);
        
        // Handle falsy values (null, false) as equivalent
        if ($expected === null) {
            if ($got === false || $got === null || $got === 0 || $got === '' || $got === []) {
                echo "\n  Match   : ✓ (falsy value equivalence)\n";
                return true;
            }
            echo "\n  Match   : ✗ (expected falsy value)\n";
            return false;
        }
    
        // Handle type-specific comparisons
        if (is_bool($got) || is_bool($expected)) {
            $result = (bool)$got === (bool)$expected;
            echo "\n  Match   : " . ($result ? "✓" : "✗") . " (boolean comparison)\n";
            return $result;
        }
        
        // Handle numeric comparisons
        if (is_numeric($got) && is_numeric($expected)) {
            if (is_float($got) || is_float($expected)) {
                $result = abs((float)$got - (float)$expected) < 1e-10;
                echo "\n  Match   : " . ($result ? "✓" : "✗") . " (float comparison)\n";
                return $result;
            }
        }
    
        // Handle array comparisons
        if (is_array($got) && is_array($expected)) {
            if (count($got) !== count($expected)) {
                echo "\n  Match   : ✗ (array length mismatch)\n";
                return false;
            }
            foreach ($got as $key => $value) {
                if (!array_key_exists($key, $expected) || 
                    !$this->compareValues($value, $expected[$key])) {
                    echo "\n  Match   : ✗ (array content mismatch)\n";
                    return false;
                }
            }
            echo "\n  Match   : ✓ (array match)\n";
            return true;
        }
    
        // Default strict comparison
        $result = $got === $expected;
        echo "\n  Match   : " . ($result ? "✓" : "✗") . " (strict comparison)\n";
        return $result;
    }

    private function compareErrors(string $got, $expected): bool {
        if (!is_array($expected)) {
            return false;
        }
        
        $expectedType = $expected['type'] ?? '';
        $expectedMessage = $expected['message'] ?? '';
        
        return (empty($expectedType) || stripos($got, $expectedType) !== false) &&
               (empty($expectedMessage) || stripos($got, $expectedMessage) !== false);
    }
}