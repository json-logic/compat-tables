use crate::types::*;
use datalogic_rs::{JsonLogic, Rule};
use serde_json::Value;
use crate::test::case::TestCase;

pub struct TestRunner {
    engine: JsonLogicEngine,
}

impl TestRunner {
    pub fn new(engine: JsonLogicEngine) -> Self {
        Self { engine }
    }

    pub fn run_test(&self, case: TestCase) -> TestResult<()> {
        let result = match self.engine {
            JsonLogicEngine::DataLogic => {
                let rule = Rule::from_value(case.logic).unwrap();
                JsonLogic::apply(&rule, case.data)
                    .map_err(|e| e.to_string())
            },
            JsonLogicEngine::JsonLogic => {
                jsonlogic::apply(case.logic, case.data)
                    .map_err(|e| e.to_string())
            },
            JsonLogicEngine::JsonLogicRs => {
                jsonlogic_rs::apply(case.logic, case.data)
                    .map_err(|e| e.to_string())
            },
        };

        match result {
            Ok(value) => {
                self.compare_values(&value, case.expected_value)
                    .map_err(|e| format!("[{}] {}", self.engine, e).into())
            },
            Err(error) => {
                if self.compare_errors(&error, case.expected_error) {
                    Ok(())
                } else {
                    Err(format!(
                        "[{}] Error mismatch\nExpected: {:?}\nGot: {:?}", 
                        self.engine, case.expected_error, error
                    ).into())
                }
            }
        }
    }

    fn compare_values(&self, got: &Value, expected: &Value) -> TestResult<()> {
        if got == expected {
            return Ok(());
        }

        // Special handling for floating-point numbers
        if let (Value::Number(g), Value::Number(e)) = (got, expected) {
            if let (Some(g_f64), Some(e_f64)) = (g.as_f64(), e.as_f64()) {
                if (g_f64 - e_f64).abs() < f64::EPSILON {
                    return Ok(());
                }
            }
        }

        // Special handling for arrays
        if let (Value::Array(g), Value::Array(e)) = (got, expected) {
            if g.len() == e.len() && g.iter().zip(e).all(|(g_val, e_val)| {
                self.compare_values(g_val, e_val).is_ok()
            }) {
                return Ok(());
            }
        }

        // Special handling for objects
        if let (Value::Object(g), Value::Object(e)) = (got, expected) {
            if g.len() == e.len() && g.iter().all(|(key, g_val)| {
                e.get(key).map_or(false, |e_val| self.compare_values(g_val, e_val).is_ok())
            }) {
                return Ok(());
            }
        }

        Err(format!(
            "Value mismatch\nExpected: {:#?}\nGot: {:#?}", 
            expected, got
        ).into())
    }
    
    fn compare_errors(&self, got: &str, expected: &Value) -> bool {
        // Try to parse the error string as JSON first
        if let Ok(got_json) = serde_json::from_str::<Value>(got) {
            if let Value::Object(got_obj) = got_json {
                if let Some(got_type) = got_obj.get("type") {
                    return self.compare_error_types(got_type, expected);
                }
            }
        }

        // Fallback to string comparison
        if let Value::Object(error_data) = expected {
            if let Some(expected_type) = error_data.get("type") {
                let normalized_got = self.normalize_error(got);
                let normalized_expected = self.normalize_error(&expected_type.to_string());
                return normalized_got == normalized_expected;
            }
        }
        false
    }

    fn compare_error_types(&self, got: &Value, expected: &Value) -> bool {
        if let Value::Object(expected_obj) = expected {
            if let Some(expected_type) = expected_obj.get("type") {
                let normalized_got = self.normalize_error(&got.to_string());
                let normalized_expected = self.normalize_error(&expected_type.to_string());
                return normalized_got == normalized_expected;
            }
        }
        false
    }

    fn normalize_error(&self, error: &str) -> String {
        error.trim_matches('"')
            .trim()
            .to_lowercase()
            .replace(r#"\"type\":\""#, "")
            .replace(r#"\""#, "")
            .replace("{", "")
            .replace("}", "")
    }
}
