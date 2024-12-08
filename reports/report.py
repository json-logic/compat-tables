import json
import pandas as pd
import os

def load_test_results(filename):
    try:
        with open(filename, 'r') as file:
            data = json.load(file)
            results = []
            
            for feature in data:
                feature_name = feature.get('name', 'Unknown Feature')
                
                for element in feature.get('elements', []):
                    scenario_name = element.get('name', 'Unknown Scenario')
                    steps = element.get('steps', [])
                    
                    # Check if all steps passed
                    all_steps_status = [step.get('result', {}).get('status', '').lower() for step in steps]
                    scenario_status = 'passed' if all(status == 'passed' for status in all_steps_status) else 'failed'
                    
                    results.append({
                        'feature': feature_name,
                        'scenario': scenario_name,
                        'status': scenario_status,
                        'total_steps': len(steps),
                        'library': os.path.splitext(os.path.basename(filename))[0]
                    })
            
            return results
    except FileNotFoundError:
        print(f"Warning: File {filename} not found")
        return []

def get_status_emoji(passed, total):
    pass_rate = passed / total
    if pass_rate == 1.0:
        return "✅"  # All passed
    elif pass_rate > 0:
        return "⚠️"  # Partial pass
    elif pass_rate == 0:
        return "❌"  # All failed

def compare_libraries():
    files = [
        'rust-datalogic-rs.json',
        'rust-jsonlogic.json',
        'rust-jsonlogic-rs.json',
        'json-logic-js.json',
        'json-logic-engine.json'
    ]
    
    all_results = []
    for file in files:
        results = load_test_results(file)
        all_results.extend(results)
    
    df = pd.DataFrame(all_results)
    
    # Group by library and feature
    grouped = df.groupby(['library', 'feature']).agg({
        'scenario': 'count',
        'status': lambda x: (x == 'passed').sum()
    }).reset_index()
    
    # Format as passed/total with emoji
    def format_result(row):
        passed = row['status']
        total = row['scenario']
        emoji = get_status_emoji(passed, total)
        return f"{passed}/{total} {emoji}"
    
    grouped['result'] = grouped.apply(format_result, axis=1)
    
    # Pivot to get features as columns
    summary = grouped.pivot(
        index='library',
        columns='feature',
        values='result'
    )
    
    # Add total column with emoji
    totals = df.groupby('library').agg({
        'scenario': 'count',
        'status': lambda x: (x == 'passed').sum()
    })
    
    summary['Total'] = totals.apply(
        lambda row: f"{row['status']}/{row['scenario']} {get_status_emoji(row['status'], row['scenario'])}", 
        axis=1
    )
    
    # Console output
    print("\nTest Results Summary:")
    print("===================")
    print(summary)
    
    # Generate markdown content
    markdown_content = "# Test Results Comparison\n\n"
    markdown_content += "Results format: passed/total scenarios\n\n"
    markdown_content += summary.to_markdown()
    
    # Write to README.md
    with open('../README.md', 'w') as f:
        f.write(markdown_content)
    
    print("\nResults exported to README.md")

if __name__ == "__main__":
    compare_libraries()