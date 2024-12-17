def before_scenario(context, scenario):
    context.rule = None
    context.data = None
    context.result = None
    context.execution_time = 0

def after_scenario(context, scenario):
    # Optional: Add timing info to scenario
    if scenario.status == "passed" and hasattr(context, "execution_time"):
        if not scenario.steps:
            return
        # Add execution time to last step for reporting
        last_step = scenario.steps[-1]
        if not hasattr(last_step, "duration"):
            last_step.duration = 0
        last_step.duration = context.execution_time