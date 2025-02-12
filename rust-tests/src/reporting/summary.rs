use crate::types::*;
use std::collections::BTreeMap;
use serde::Serialize;
use serde_json::json;
use std::fs;

#[derive(Debug, Serialize)]
pub struct EngineStats {
    pub passed: i32,
    pub total: i32,
    pub success_rate: f64,
}

#[derive(Debug)]
pub struct TestSummary {
    results_by_suite: BTreeMap<String, BTreeMap<JsonLogicEngine, EngineResults>>,
    totals: BTreeMap<JsonLogicEngine, EngineResults>,
}

impl TestSummary {
    pub fn new() -> Self {
        Self {
            results_by_suite: BTreeMap::new(),
            totals: BTreeMap::new(),
        }
    }

    pub fn add_result(&mut self, suite_name: String, engine: JsonLogicEngine, result: EngineResults) {
        self.results_by_suite
            .entry(suite_name)
            .or_default()
            .insert(engine, result.clone());

        let total = self.totals
            .entry(engine)
            .or_insert_with(|| EngineResults { passed: 0, total: 0 });
        total.passed += result.passed;
        total.total += result.total;
    }

    pub fn print_summary(&self) {
        self.print_header();
        self.print_results();
        self.print_totals();
    }

    fn print_header(&self) {
        println!("\n{:=^80}", " Test Results Summary ");
        print!("{:<30} ", "Test Suite");
        for engine in JsonLogicEngine::all() {
            print!("{:>15} ", format!("{:?}", engine));
        }
        println!("\n{:-<80}", "");
    }

    fn print_results(&self) {
        for (suite, results) in &self.results_by_suite {
            print!("{:<30} ", suite);
            for engine in JsonLogicEngine::all() {
                if let Some(result) = results.get(&engine) {
                    print!("{:>7}/{:<7} ", result.passed, result.total);
                } else {
                    print!("{:>15} ", "N/A");
                }
            }
            println!();
        }
    }

    fn print_totals(&self) {
        println!("{:-<80}", "");
        print!("{:<30} ", "TOTAL");
        for engine in JsonLogicEngine::all() {
            if let Some(total) = self.totals.get(&engine) {
                print!("{:>7}/{:<7} ", total.passed, total.total);
            } else {
                print!("{:>15} ", "N/A");
            }
        }
        println!();
        
        // Print percentage
        print!("{:<30} ", "Success Rate");
        for engine in JsonLogicEngine::all() {
            if let Some(total) = self.totals.get(&engine) {
                let percentage = (total.passed as f64 / total.total as f64) * 100.0;
                print!("{:>15.2}% ", percentage);
            } else {
                print!("{:>15} ", "N/A");
            }
        }
        println!();
    }

    pub fn save_json(&self, output_path: &str) -> TestResult<()> {
        let summary_json = self.create_summary_json();
        let json_content = serde_json::to_string_pretty(&summary_json)?;
        fs::write(output_path, json_content)?;
        Ok(())
    }

    fn create_summary_json(&self) -> serde_json::Value {
        let mut summary = json!({
            "test_suites": {},
            "totals": {},
        });

        // Add suite results
        if let Some(suites) = summary.get_mut("test_suites") {
            let suites_obj = suites.as_object_mut().unwrap();
            for (suite_name, results) in &self.results_by_suite {
                let mut suite_stats = serde_json::Map::new();
                for (engine, result) in results {
                    suite_stats.insert(
                        engine.to_string(),
                        json!({
                            "passed": result.passed,
                            "total": result.total,
                        })
                    );
                }
                suites_obj.insert(suite_name.clone(), json!(suite_stats));
            }
        }

        // Add totals
        if let Some(totals) = summary.get_mut("totals") {
            let totals_obj = totals.as_object_mut().unwrap();
            for (engine, result) in &self.totals {
                totals_obj.insert(
                    engine.to_string(),
                    json!({
                        "passed": result.passed,
                        "total": result.total,
                    })
                );
            }
        }

        summary
    }
}