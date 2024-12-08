use serde_json::Value;
use cucumber::{given, then, when, World, writer};
use datalogic_rs::JsonLogic;
use std::time::Instant;
use std::sync::atomic::{AtomicU64, Ordering};
use std::fs;

static EXECUTION_TIME: AtomicU64 = AtomicU64::new(0);

#[derive(cucumber::World, Debug, Default)]
struct JSONLogicWorld {
    rule: Option<Value>,
    data: Option<Value>,
    result: Option<Value>,
}

#[given(expr = "the rule {string}")]
async fn given_rule(world: &mut JSONLogicWorld, rule_str: String) {
    let clean_str = rule_str.replace("\\\"", "\"");
    
    match serde_json::from_str(&clean_str) {
        Ok(value) => world.rule = Some(value),
        Err(e) => panic!("Failed to parse rule JSON: {} \nInput was: {}", e, clean_str),
    }
}

#[given(expr = "the data {string}")]
async fn given_data(world: &mut JSONLogicWorld, data_str: String) {
    let clean_str = data_str.replace("\\\"", "\"");
    
    match serde_json::from_str(&clean_str) {
        Ok(value) => world.data = Some(value),
        Err(e) => panic!("Failed to parse data JSON: {} \nInput was: {}", e, clean_str),
    }
}

#[when("I evaluate the rule")]
async fn evaluate_rule(world: &mut JSONLogicWorld) {
    let rule = world.rule.as_ref().unwrap();
    let data = world.data.as_ref().unwrap_or(&Value::Null);
    let logic = JsonLogic::new();

    let start = Instant::now();
    world.result = Some(logic.apply(rule, data).unwrap());
    let duration = start.elapsed().as_nanos() as u64;
    EXECUTION_TIME.fetch_add(duration, Ordering::Relaxed);
}

#[then(expr = "the result should be {string}")]
async fn check_result(world: &mut JSONLogicWorld, expected: String) {
    let clean_str = expected.replace("\\\"", "\"");
    let expected: Value = serde_json::from_str(&clean_str)
        .unwrap_or_else(|e| panic!("Failed to parse expected JSON: {} \nInput was: {}", e, clean_str));
    
    let actual = world.result.as_ref().unwrap();
    assert_eq!(actual, &expected);
}

#[tokio::main]
async fn main() {
    let file = fs::File::create("report.json")
        .expect("Failed to create report file");

    JSONLogicWorld::cucumber()
        .with_writer(writer::Json::new(file))
        .run("../features/")
        .await;

    println!("Total execution time: {} ns", EXECUTION_TIME.load(Ordering::Relaxed));
}