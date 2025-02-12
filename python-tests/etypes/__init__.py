from enum import Enum
from dataclasses import dataclass
from typing import Dict, Optional

class JsonLogicEngine(Enum):
    QUBIT = "Qubit"
    PANZI = "Panzi"

    @staticmethod
    def all():
        return [JsonLogicEngine.QUBIT, JsonLogicEngine.PANZI]

@dataclass
class EngineStats:
    passed: int = 0
    total: int = 0

    @property
    def success_rate(self) -> float:
        return (self.passed / self.total * 100) if self.total > 0 else 0.0