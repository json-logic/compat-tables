import json
from typing import Any, Tuple
from etypes import JsonLogicEngine  # Updated import
from test.case import TestCase     # Updated import

from json_logic import jsonLogic

class TestRunner:
    def __init__(self, engine: JsonLogicEngine):
        self.engine = engine

    def run_test(self, case: TestCase) -> bool:
        try:
            result = self._apply_rule(case.logic, case.data)
            
            if case.expected_error:
                return False
            
            return self._compare_values(result, case.expected_value)
        except Exception as e:
            if not case.expected_error:
                return False
            return self._compare_errors(str(e), case.expected_error)

    def _apply_rule(self, rule: Any, data: Any) -> Any:
        if self.engine == JsonLogicEngine.QUBIT:
            return jsonLogic(rule, data)
        elif self.engine == JsonLogicEngine.PANZI:
            return jsonLogic(rule, data)
        raise ValueError(f"Unknown engine: {self.engine}")

    def _compare_values(self, got: Any, expected: Any) -> bool:
        if isinstance(got, float) and isinstance(expected, float):
            return abs(got - expected) < 1e-10
        return got == expected

    def _compare_errors(self, got: str, expected: Any) -> bool:
        if isinstance(expected, dict) and 'type' in expected:
            expected_type = expected['type'].lower()
            return expected_type in got.lower()
        return False