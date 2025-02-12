use serde_json::Value;

#[derive(Debug)]
pub struct TestCase<'a> {
    pub logic: &'a Value,
    pub data: &'a Value,
    pub expected_value: &'a Value,
    pub expected_error: &'a Value,
}

impl<'a> TestCase<'a> {
    pub fn from_value(value: &'a Value) -> Option<Self> {
        if let Value::Object(obj) = value {
            Some(TestCase {
                logic: obj.get("rule")?,
                data: obj.get("data").unwrap_or(&Value::Null),
                expected_value: obj.get("result").unwrap_or(&Value::Null),
                expected_error: obj.get("error").unwrap_or(&Value::Null),
            })
        } else {
            None
        }
    }
}