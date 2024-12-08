import json
import re
import os
import argparse
from pathlib import Path

def format_json_string(json_obj):
    """Convert JSON object to properly escaped string for Gherkin"""
    return json.dumps(json_obj).replace('"', '\\"')

def generate_feature_files(input_file, output_dir):
    # Create output directory if it doesn't exist
    Path(output_dir).mkdir(parents=True, exist_ok=True)
    
    # Read JSON file
    with open(input_file, 'r') as f:
        test_cases = json.load(f)
    
    current_feature = []
    current_category = "Basic Operations"
    
    for test in test_cases:
        # Handle category comments
        if isinstance(test, str) and test.startswith('#'):
            if current_feature:
                # Write previous feature
                write_feature_file(current_category, current_feature, output_dir)
                current_feature = []
            current_category = test.replace('#', '').strip()
            continue
            
        if isinstance(test, dict):
            # Generate scenario
            scenario = f"""
  Scenario: {test['description']}
    Given the rule '{format_json_string(test['rule'])}'
    And the data '{format_json_string(test['data'])}'
    When I evaluate the rule
    Then the result should be '{format_json_string(test['result'])}'
"""
            current_feature.append(scenario)
    
    # Write final feature
    if current_feature:
        write_feature_file(current_category, current_feature, output_dir)

def write_feature_file(category, scenarios, output_dir):
    """Write scenarios to feature file"""
    filename = os.path.join(output_dir, f"{category.lower().replace(' ', '_')}.feature")
    
    content = f"""Feature: {category}

  Testing {category.lower()} operations in JsonLogic
{"".join(scenarios)}"""

    with open(filename, 'w') as f:
        f.write(content)

def main():
    parser = argparse.ArgumentParser(description='Convert JSON test cases to Gherkin features')
    parser.add_argument('input_file', help='Input JSON test cases file')
    parser.add_argument('output_dir', help='Output directory for feature files')
    
    args = parser.parse_args()
    
    # Validate input file exists
    if not os.path.exists(args.input_file):
        print(f"Error: Input file '{args.input_file}' does not exist")
        return 1
        
    generate_feature_files(args.input_file, args.output_dir)
    return 0

if __name__ == "__main__":
    exit(main())