from behave import given, when, then
from json_logic import jsonLogic
import json
import time
import os

LIBRARY = os.getenv('JSONLOGIC_LIBRARY', 'json-logic-qubit')

if LIBRARY == 'python-jsonlogic':
    from jsonlogic.operators import operator_registry
    from jsonlogic import JSONLogicExpression
    from jsonlogic.evaluation import evaluate
elif LIBRARY == 'json-logic-qubit':
    from json_logic import jsonLogic
elif LIBRARY == 'panzi-json-logic':
    from json_logic import jsonLogic

@given('the rule {rule_str}')
def given_rule(context, rule_str):
    clean_str = rule_str.strip("'")
    clean_str = clean_str.replace('\\"', '"')
    try:
        context.rule = json.loads(clean_str)
    except json.JSONDecodeError as e:
        raise Exception(f"Failed to parse rule JSON: {e}\nInput was: {clean_str}")

@given('the data {data_str}') 
def given_data(context, data_str):
    clean_str = data_str.strip("'")
    clean_str = clean_str.replace('\\"', '"')
    try:
        context.data = json.loads(clean_str)
    except json.JSONDecodeError as e:
        raise Exception(f"Failed to parse data JSON: {e}\nInput was: {clean_str}")

@when('I evaluate the rule')
def evaluate_rule(context):
    start = time.perf_counter_ns()
    print(f"Rule: {type(context.rule)}:{json.dumps(context.rule)}, Data: {type(context.data)}:{context.data}")
    try:
        if LIBRARY == 'python-jsonlogic':
            expr = JSONLogicExpression.from_json(context.rule)
            root_op = expr.as_operator_tree(operator_registry)
            context.result = evaluate(root_op, context.data, data_schema=None)
        else:
            context.result = jsonLogic(context.rule, context.data)
        context.execution_time = time.perf_counter_ns() - start
    except Exception as e:
        context.execution_time = time.perf_counter_ns() - start
        raise e

@then('the result should be {expected_str}')
def check_result(context, expected_str):
    clean_str = expected_str.strip("'")
    clean_str = clean_str.replace('\\"', '"')
    try:
        expected = json.loads(clean_str)
    except json.JSONDecodeError as e:
        raise Exception(f"Failed to parse expected JSON: {e}\nInput was: {clean_str}")
    
    assert context.result == expected