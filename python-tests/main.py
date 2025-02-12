import json
import os
from typing import Dict, List, Any
from engines.test_runner import TestRunner
from etypes import JsonLogicEngine
from test.case import TestCase
from reporting.summary import TestSummary

def load_test_suites() -> Dict[str, List[dict]]:
    with open('../suites/index.json') as f:
        test_files = json.load(f)

    suites = {}
    for file_name in test_files:
        with open(f'../suites/{file_name}') as f:
            suites[file_name] = json.load(f)
    
    return suites

def run_engine_tests(engine: JsonLogicEngine, suite: List[dict]) -> tuple[int, int]:
    passed = total = 0
    runner = TestRunner(engine)

    for case_data in suite:
        if not isinstance(case_data, dict):
            continue
            
        total += 1
        case = TestCase.from_dict(case_data)
        
        if runner.run_test(case):
            passed += 1
        else:
            print(f"Test failed for {engine.value}")

    return passed, total

def run_suite_tests(summary: TestSummary, suite_name: str, suite: List[dict]):
    print(f"\nRunning suite: {suite_name}")
    
    LIBRARY = os.getenv('LIBRARY', 'json-logic-qubit')

    if LIBRARY == 'json-logic-qubit':
        engine = JsonLogicEngine.QUBIT
        passed, total = run_engine_tests(engine, suite)
        summary.add_result(suite_name, engine, passed, total)
    elif LIBRARY == 'panzi-json-logic':
        engine = JsonLogicEngine.PANZI
        passed, total = run_engine_tests(engine, suite)
        summary.add_result(suite_name, engine, passed, total)
    else:
        print(f"Unknown library: {LIBRARY}")

def load_existing_summary(filename: str) -> Dict:
    try:
        with open(filename, 'r') as f:
            return json.load(f)
    except (FileNotFoundError, json.JSONDecodeError):
        return {
            "test_suites": {},
            "totals": {},
            "timestamp": [],
            "python_version": []
        }

def main():
    suites = load_test_suites()
    print(f"Successfully loaded {len(suites)} test suites")

    summary = TestSummary()
    
    results_file = "../results/python.json"
    existing_results = load_existing_summary(results_file)
    summary.load_existing_results(existing_results)

    # Run new tests
    for name, suite in suites.items():
        run_suite_tests(summary, name, suite)

    summary.print_summary()
    summary.save_json(results_file)

if __name__ == "__main__":
    main()