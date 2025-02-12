from dataclasses import dataclass
from typing import Any, Optional

@dataclass
class TestCase:
    logic: Any
    data: Any
    expected_value: Any
    expected_error: Optional[Any] = None

    @classmethod
    def from_dict(cls, data: dict) -> 'TestCase':
        return cls(
            logic=data.get('rule'),
            data=data.get('data'),
            expected_value=data.get('result'),
            expected_error=data.get('error')
        )