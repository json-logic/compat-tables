<?php
namespace JsonLogicCompat\Test;

class TestCase {
    public $logic;
    public $data;
    public $expectedValue;
    public $expectedError;

    public static function fromArray(array $data): self {
        $case = new self();
        $case->logic = $data['rule'] ?? null;
        $case->data = $data['data'] ?? null;
        $case->expectedValue = $data['result'] ?? null;
        $case->expectedError = $data['error'] ?? null;
        return $case;
    }
}