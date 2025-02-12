mod types;
mod engines;
mod test;
mod reporting;

use types::{TestResult, JsonLogicEngine, EngineResults};
use test::case::TestCase;
use engines::test_runner::TestRunner;
use reporting::summary::TestSummary;
use std::{
    collections::HashMap,
    fs,
    path::Path,
};
use serde_json::Value;

/// Loads all test suites from the suites directory
fn load_test_suites() -> TestResult<HashMap<String, Value>> {
    let index_path = Path::new("../suites/index.json");
    let index_content = fs::read_to_string(index_path)?;
    let test_files: Vec<String> = serde_json::from_str(&index_content)?;
    
    let mut test_suites = HashMap::new();
    for file_name in test_files {
        let file_path = Path::new("../suites").join(&file_name);
        let content = fs::read_to_string(&file_path)?;
        let suite: Value = serde_json::from_str(&content)?;
        test_suites.insert(file_name, suite);
    }
    
    Ok(test_suites)
}

/// Runs all test cases in a suite for a specific engine
fn run_engine_tests(engine: JsonLogicEngine, suite: &[Value]) -> TestResult<EngineResults> {
    let mut results = EngineResults::new();
    let runner = TestRunner::new(engine);

    for case in suite {
        if let Some(test_case) = TestCase::from_value(case) {
            match runner.run_test(test_case) {
                Ok(_) => {
                    results.increment_passed();
                },
                Err(e) => {
                    results.increment_failed();
                    println!("Test failed for {:?}: {}", engine, e);
                }
            }
        }
    }
    
    Ok(results)
}

/// Runs all tests in a suite for all engines
fn run_suite_tests(summary: &mut TestSummary, file_name: &str, suite: Value) -> TestResult<()> {
    if let Some(test_cases) = suite.as_array() {
        println!("\nRunning suite: {}", file_name);
        
        for engine in JsonLogicEngine::all() {
            if let Ok(results) = run_engine_tests(engine, test_cases) {
                summary.add_result(file_name.to_string(), engine, results);
            }
        }
    }
    
    Ok(())
}

fn main() -> TestResult<()> {
    let suites = load_test_suites()?;
    println!("Successfully loaded {} test suites", suites.len());
    
    let mut summary = TestSummary::new();
    for (file_name, suite) in suites {
        run_suite_tests(&mut summary, &file_name, suite)?;
    }

    summary.print_summary();
    
    // Save results to JSON file
    let output_path = "../results/rust.json";
    summary.save_json(output_path)?;
    println!("\nResults saved to: {}", output_path);
    
    Ok(())
}