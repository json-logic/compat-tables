import json
from datetime import datetime
import platform
from typing import Dict, Any, List
from etypes import JsonLogicEngine

class TestSummary:
    def __init__(self):
        self.current_run: Dict[str, Dict[str, Dict]] = {}
        self.current_totals: Dict[str, Dict] = {}
        self.results_by_suite: Dict[str, Dict[str, Dict]] = {}
        self.totals: Dict[str, Dict] = {}

    def add_result(self, suite_name: str, engine: JsonLogicEngine, passed: int, total: int):
        # Initialize current run results if not exists
        if suite_name not in self.current_run:
            self.current_run[suite_name] = {}

        # Add suite result for current run
        engine_key = engine.value if isinstance(engine, JsonLogicEngine) else str(engine)
        stats = {
            "passed": passed,
            "total": total,
        }
        
        self.current_run[suite_name][engine_key] = stats

        # Update current totals
        if engine_key not in self.current_totals:
            self.current_totals[engine_key] = {"passed": 0, "total": 0, "success_rate": 0}
        
        self.current_totals[engine_key]["passed"] += passed
        self.current_totals[engine_key]["total"] += total

    def load_existing_results(self, data: Dict[str, Any]):
        self.results_by_suite = data.get("test_suites", {})
        self.totals = data.get("totals", {})

    def save_json(self, filename: str):
        # Merge current run with existing results
        for suite_name, suite_results in self.current_run.items():
            if suite_name not in self.results_by_suite:
                self.results_by_suite[suite_name] = {}
            self.results_by_suite[suite_name].update(suite_results)

        # Merge current totals with existing totals
        self.totals.update(self.current_totals)

        result = {
            "test_suites": self.results_by_suite,
            "totals": self.totals,
        }

        with open(filename, 'w') as f:
            json.dump(result, f, indent=2)

    def print_summary(self):
        print("\n" + "=" * 30 + " Test Results Summary " + "=" * 30)
        
        # Print header
        print(f"{'Test Suite':<30}", end="")
        for engine in JsonLogicEngine:
            print(f"{engine.value:>15}", end="")
        print("\n" + "-" * 80)

        # Print results for current run
        for suite_name in sorted(self.current_run.keys()):
            print(f"{suite_name:<30}", end="")
            for engine in JsonLogicEngine:
                stats = self.current_run[suite_name].get(engine.value)
                if stats:
                    print(f"{stats['passed']:>7}/{stats['total']:<7}", end="")
                else:
                    print(f"{'N/A':>15}", end="")
            print()

        # Print totals for current run
        print("-" * 80)
        print(f"{'TOTAL':<30}", end="")
        for engine in JsonLogicEngine:
            if engine.value in self.current_totals:
                stats = self.current_totals[engine.value]
                print(f"{stats['passed']:>7}/{stats['total']:<7}", end="")
            else:
                print(f"{'N/A':>15}", end="")
        print()