<?php

use Behat\Behat\Context\Context;
use Behat\Gherkin\Node\PyStringNode;
use JsonLogic\JsonLogic;

class JsonLogicContext implements Context
{
    private $rules;
    private $data;
    private $result;

    private function cleanString($str) 
    {
        return str_replace('\\"', '"', $str);
    }

    /**
     * @Given the rule :rule
     */
    public function theRule($rule)
    {
        $cleaned_rule = $this->cleanString($rule);
        $this->rules = json_decode($cleaned_rule, true);
        if (json_last_error() !== JSON_ERROR_NONE) {
            throw new \Exception("Invalid JSON rule: " . json_last_error_msg());
        }
        echo "Rule loaded: " . json_encode($this->rules) . "\n";
    }

    /**
     * @Given the data :data
     */
    public function theData($data)
    {
        $cleaned_data = $this->cleanString($data);
        $this->data = json_decode($cleaned_data, true);
        if (json_last_error() !== JSON_ERROR_NONE) {
            throw new \Exception("Invalid JSON data: " . json_last_error_msg());
        }
        echo "Data loaded: " . json_encode($this->data) . "\n";
    }

    /**
     * @When I evaluate the rule
     */
    public function iEvaluateTheRule()
    {
        try {
            $this->result = JWadhams\JsonLogic::apply($this->rules, $this->data);
            echo "Result: " . json_encode($this->result) . "\n";
        } catch (\Exception $e) {
            throw new \Exception("Failed to evaluate rule: " . $e->getMessage());
        }
    }

    /**
     * @Then the result should be :expected
     */
    public function theResultShouldBe($expected)
    {
        $cleaned_expected = $this->cleanString($expected);
        $expected_value = json_decode($cleaned_expected, true);
        if ($this->result !== $expected_value) {
            throw new \Exception(sprintf(
                "Expected %s but got %s",
                json_encode($expected_value),
                json_encode($this->result)
            ));
        }
    }
}