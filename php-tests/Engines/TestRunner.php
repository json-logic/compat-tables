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

            $success = $this->compareValues($result, $case->expectedValue);
            if (!$success) {
                echo "\nTest failed for {$this->engine}";
                echo "\nRule: " . json_encode($case->logic, JSON_PRETTY_PRINT);
                echo "\nData: " . json_encode($case->data, JSON_PRETTY_PRINT);
                echo "\nExpected: " . json_encode($case->expectedValue, JSON_PRETTY_PRINT);
                echo "\nResult: " . json_encode($result, JSON_PRETTY_PRINT);
            }
            return $success;
        } catch (\Exception $e) {
            if (!$case->expectedError) {
                return false;
            }
            return $this->compareErrors($e->getMessage(), $case->expectedError);
        }
    }

    private function applyRule($rule, $data) {
        if ($this->engine === 'jwadhams') {
            $data = $data ?? [];

            // Apply the rule
            try {
                $result = JsonLogic::apply($rule, $data);
                return $result;
            } catch (\DivisionByZeroError $e) {
                echo "\nDivision by zero: " . $e->getMessage() . "\n";
                throw new \RuntimeException("Division by zero");
            } catch (\TypeError $e) {
                echo "\nType Error: " . $e->getMessage() . "\n";
                throw new \RuntimeException("Type error: " . $e->getMessage());
            } catch (\Exception $e) {
                echo "\nError: " . $e->getMessage() . "\n";
                throw new \RuntimeException("Error applying rule: " . $e->getMessage());
            }
        }
        throw new \RuntimeException("Unknown engine: {$this->engine}");
    }

    private function compareValues($got, $expected): bool {
        // Handle falsy values (null, false) as equivalent
        if ($expected === null) {
            if ($got === false || $got === null || $got === 0 || $got === '' || $got === []) {
                return true;
            }
            return false;
        }
    
        // Handle type-specific comparisons
        if (is_bool($got) || is_bool($expected)) {
            $result = (bool)$got === (bool)$expected;
            return $result;
        }
        
        // Handle numeric comparisons
        if (is_numeric($got) && is_numeric($expected)) {
            if (is_float($got) || is_float($expected)) {
                $result = abs((float)$got - (float)$expected) < 1e-10;
                return $result;
            }
        }
    
        // Handle array comparisons
        if (is_array($got) && is_array($expected)) {
            if (count($got) !== count($expected)) {
                return false;
            }
            foreach ($got as $key => $value) {
                if (!array_key_exists($key, $expected) || 
                    !$this->compareValues($value, $expected[$key])) {
                    return false;
                }
            }
            return true;
        }
    
        // Default strict comparison
        $result = $got === $expected;
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