use std::error::Error;
use std::fmt;

pub type TestResult<T> = Result<T, Box<dyn Error>>;

#[derive(Debug, Clone, Copy, Ord, PartialOrd, Eq, PartialEq)]
pub enum JsonLogicEngine {
    DataLogic,
    JsonLogic,
    JsonLogicRs,
}

impl JsonLogicEngine {
    pub fn all() -> Vec<JsonLogicEngine> {
        vec![
            JsonLogicEngine::DataLogic,
            JsonLogicEngine::JsonLogic,
            JsonLogicEngine::JsonLogicRs,
        ]
    }
}

impl fmt::Display for JsonLogicEngine {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            JsonLogicEngine::DataLogic => write!(f, "DataLogic"),
            JsonLogicEngine::JsonLogic => write!(f, "JsonLogic"),
            JsonLogicEngine::JsonLogicRs => write!(f, "JsonLogicRs"),
        }
    }
}

#[derive(Debug, Clone)]
pub struct EngineResults {
    pub passed: i32,
    pub total: i32,
}

impl EngineResults {
    pub fn new() -> Self {
        Self {
            passed: 0,
            total: 0,
        }
    }

    pub fn increment_passed(&mut self) {
        self.passed += 1;
        self.total += 1;
    }

    pub fn increment_failed(&mut self) {
        self.total += 1;
    }
}
