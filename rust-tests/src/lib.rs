pub mod test_utils {
    use serde_json::Value;
    use std::fs;
    
    pub fn load_test_cases() -> Vec<Value> {
        let test_data = fs::read_to_string("../../test-data/test-cases.json")
            .expect("Failed to read test cases");
        serde_json::from_str(&test_data)
            .expect("Failed to parse test cases")
    }
}