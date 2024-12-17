import json
import pandas as pd
import os

from datetime import datetime

def parse_date(date_str):
    try:
        # Try parsing ISO format with timezone
        if 'T' in date_str:
            dt = datetime.fromisoformat(date_str.replace('Z', '+00:00'))
            return dt.strftime('%Y-%m-%d')
        # Try parsing simple date format
        return datetime.strptime(date_str, '%Y-%m-%d').strftime('%Y-%m-%d')
    except ValueError:
        return date_str
    
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

def load_version_info(version_file):
    try:
        with open(version_file, 'r') as f:
            versions = json.load(f)
            if not isinstance(versions, list):
                print(f"Warning: Unexpected format in {version_file}")
                return {}
            # Create dictionary with formatted dates
            return {str(v.get('library')): {
                'version': v.get('version'),
                'date': parse_date(v.get('date', ''))
            } for v in versions if isinstance(v, dict)}
    except FileNotFoundError:
        print(f"Warning: Version file {version_file} not found")
        return {}
    except json.JSONDecodeError:
        print(f"Warning: Invalid JSON in {version_file}")
        return {}

def update_library_info(libraries):
    for lib in libraries:
        version_info = load_version_info(lib['version_report'])
        if version_info and lib['name'] in version_info:
            lib.update({
                'version': version_info[lib['name']]['version'],
                'release_date': version_info[lib['name']]['date']
            })
    return libraries

def get_status_emoji(passed, total):
    pass_rate = passed / total
    if pass_rate == 1.0:
        return "✅"  # All passed
    elif pass_rate > 0:
        return "⚠️"  # Partial pass
    elif pass_rate == 0:
        return "❌"  # All failed

def compare_libraries(libraries):
    all_results = []
    for lib in libraries:
        results = load_test_results(lib['report'])
        for result in results:
            result.update({
                'library': lib['name'],
                'language': lib['language'],
                'version': lib.get('version', 'unknown'),
                'release_date': lib.get('release_date', 'unknown'),
                'homepage': lib.get('homepage', '')
            })
        all_results.extend(results)
    
    df = pd.DataFrame(all_results)
    
    # Group by library and feature
    grouped = df.groupby(['library', 'feature']).agg({
        'scenario': 'count',
        'status': lambda x: (x == 'passed').sum(),
        'language': 'first',
        'version': 'first',
        'release_date': 'first',
        'homepage': 'first'
    }).reset_index()
    
    # Format as passed/total with emoji
    def format_result(row):
        passed = row['status']
        total = row['scenario']
        emoji = get_status_emoji(passed, total)
        return f"{passed}/{total} {emoji}", passed/total if total > 0 else 0

    grouped['result'], grouped['pass_rate'] = zip(*grouped.apply(format_result, axis=1))

    # Calculate total passed and scenarios per library
    library_totals = grouped.groupby(['library', 'language', 'version', 'release_date', 'homepage']).agg({
        'status': 'sum',
        'scenario': 'sum'
    }).reset_index()
    library_totals['pass_rate'] = library_totals['status'] / library_totals['scenario']

    # Sort libraries by pass rate and language
    sorted_libraries = library_totals.sort_values(
        ['pass_rate', 'language'], 
        ascending=[False, True]
    )['library'].tolist()

    # Pivot to get features as columns
    summary = grouped.pivot(
        index=['library', 'language', 'version', 'release_date', 'homepage'],
        columns='feature',
        values='result'
    ).reset_index()
    
    # Pivot with sorted index
    summary = grouped.pivot(
        index=['library', 'language', 'version', 'release_date', 'homepage'],
        columns='feature',
        values='result'
    ).reset_index()

    # Reorder based on sorted libraries
    summary['sort_key'] = summary['library'].map({lib: i for i, lib in enumerate(sorted_libraries)})
    summary = summary.sort_values('sort_key').drop('sort_key', axis=1)

    # Create markdown links for library names
    summary['library'] = summary.apply(
        lambda x: f"**[{x['library']}]({x['homepage']}) {x['language']}**" if x['homepage'] else x['library'], 
        axis=1
    )

    summary['version'] = summary.apply(
        lambda x: f"{x['version']} ({x['release_date']})", 
        axis=1
    )
    
    # Set library as index and drop homepage column
    summary = summary.set_index('library').drop(['homepage', 'language', 'release_date'], axis=1)
    
    # Generate markdown
    markdown_content = "# Test Results Comparison\n\n"
    markdown_content += "Status Key:\n\n"
    markdown_content += "- ✅ All tests passing\n"
    markdown_content += "- ⚠️ Some tests failing\n"
    markdown_content += "- ❌ Not supported/Not implemented\n\n"
    markdown_content += "Results format: passed/total scenarios\n\n"
    markdown_content += summary.to_markdown()
    
    return summary, markdown_content

if __name__ == "__main__":
    libraries = [
        {
            "name" : "datalogic-rs",
            "language" : "Rust",
            "report" : "rust-datalogic-rs.json",
            "version_report": "../rust-tests/version.json",
            "homepage": "https://github.com/Open-Payments/datalogic-rs"
        },
        {
            "name" : "jsonlogic",
            "language" : "Rust",
            "report" : "rust-jsonlogic.json",
            "version_report": "../rust-tests/version.json",
            "homepage": "https://github.com/marvindv/jsonlogic_rs"
        },
        {
            "name" : "jsonlogic-rs",
            "language" : "Rust",
            "report" : "rust-jsonlogic-rs.json",
            "version_report": "../rust-tests/version.json",
            "homepage": "https://github.com/Bestowinc/json-logic-rs"
        },
        {
            "name" : "json-logic-js",
            "language" : "JavaScript",
            "report" : "json-logic-js.json",
            "version_report": "../js-tests/version.json",
            "homepage": "https://github.com/jwadhams/json-logic-js"
        },
        {
            "name" : "json-logic-engine",
            "language" : "JavaScript",
            "report" : "json-logic-engine.json",
            "version_report": "../js-tests/version.json",
            "homepage": "https://github.com/TotalTechGeek/json-logic-engine"
        },
        {
            "name" : "diegoholiveira/jsonlogic/v3",
            "language" : "Go",
            "report" : "diegoholiveira.json",
            "version_report": "../go-tests/version.json",
            "homepage": "https://github.com/diegoholiveira/jsonlogic"
        },
        {
            "name" : "HuanTeng/go-jsonlogic",
            "language" : "Go",
            "report" : "huanteng.json",
            "version_report": "../go-tests/version.json",
            "homepage": "https://github.com/HuanTeng/go-jsonlogic"
        },
        {
            "name" : "python-jsonlogic",
            "language" : "Python",
            "report" : "python-python-jsonlogic.json",
            "version_report": "../python-tests/version.json",
            "homepage": "https://github.com/Viicos/jsonlogic"
        },
        {
            "name" : "panzi-json-logic",
            "language" : "Python",
            "report" : "python-panzi-json-logic.json",
            "version_report": "../python-tests/version.json",
            "homepage": "https://github.com/panzi/panzi-json-logic"
        },
        {
            "name" : "json-logic-qubit",
            "language" : "Python",
            "report" : "python-json-logic-qubit.json",
            "version_report": "../python-tests/version.json",
            "homepage": "https://github.com/nadirizr/json-logic-py"
        },
        {
            "name" : "json-logic-php",
            "language" : "PHP",
            "report" : "php-json-logic-php.json",
            "version_report": "../php-tests/version.json",
            "homepage": "https://github.com/jwadhams/json-logic-php"
        }
    ]
    updated_libraries = update_library_info(libraries)
    summary, markdown = compare_libraries(updated_libraries)
    
    with open('../README.md', 'w') as f:
        f.write(markdown)