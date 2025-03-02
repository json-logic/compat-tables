import json
import os
import shutil
from typing import Dict, Any, Tuple, List
from datetime import datetime
from jinja2 import Environment, FileSystemLoader

def load_results(directory: str) -> Dict[str, Any]:
    results = {}
    for filename in os.listdir(directory):
        if not filename.endswith('.json'):
            continue
            
        language = filename.split('.')[0]
        with open(os.path.join(directory, filename), 'r') as f:
            results[language] = json.load(f)
    return results

def create_summary_table(results: Dict[str, Any]) -> Dict[str, Any]:
    # Collect all test suites and engines
    all_suites = set()
    engine_by_lang = {}
    
    # Create a mapping of engine to language
    engine_lang_map = {}
    for lang, lang_results in results.items():
        all_suites.update(lang_results.get('test_suites', {}).keys())
        for suite_results in lang_results.get('test_suites', {}).values():
            if lang not in engine_by_lang:
                engine_by_lang[lang] = set()
            engines = suite_results.keys()
            engine_by_lang[lang].update(engines)
            # Map each engine to its language
            for engine in engines:
                engine_lang_map[engine] = lang

    # Prepare template data
    template_data = {
        'generated_time': datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
        'table_headers': {
            'test_suite': 'Test Suite'
        },
        'engines': [],
        'test_suites': [],
        'totals': [],
        'success_rates': []
    }
    
    # Add engines with language icons
    ICONS = {
        'go': '<i class="devicon-go-original-wordmark"></i>',
        'python': '<i class="devicon-python-plain"></i>',
        'rust': '<i class="devicon-rust-original"></i>',
        'php': '<i class="devicon-php-plain"></i>',
        'javascript': '<i class="devicon-javascript-plain"></i>',
        'java': '<i class="devicon-java-plain"></i>',
        'csharp': '<i class="devicon-csharp-plain"></i>',
    }
    
    # Create ordered list of all engines
    all_engines = []
    for lang, engines in sorted(engine_by_lang.items()):
        for engine in sorted(engines):
            all_engines.append(engine)
            template_data['engines'].append({
                'name': engine,
                'icon': ICONS.get(engine_lang_map.get(engine, '').lower(), '')
            })
    
    # Add test suite rows
    for suite in sorted(all_suites):
        # Get total test cases from first non-empty result
        total_cases = 0
        for lang, lang_results in results.items():
            suite_results = lang_results.get('test_suites', {}).get(suite, {})
            for stats in suite_results.values():
                total_cases = stats.get('total', 0)
                if total_cases > 0:
                    break
            if total_cases > 0:
                break
        
        suite_data = {
            'name': suite,
            'total_cases': total_cases,
            'results': []
        }
        
        for engine in all_engines:
            lang = engine_lang_map.get(engine, '')
            if lang and suite in results[lang].get('test_suites', {}):
                suite_results = results[lang]['test_suites'][suite]
                if engine in suite_results:
                    stats = suite_results[engine]
                    passed = stats.get('passed', 0)
                    success_class = get_success_class(passed, total_cases)
                    suite_data['results'].append({
                        'value': f"{passed:>3}",
                        'class': success_class
                    })
                else:
                    suite_data['results'].append({
                        'value': 'N/A',
                        'class': 'na'
                    })
            else:
                suite_data['results'].append({
                    'value': 'N/A',
                    'class': 'na'
                })
        
        template_data['test_suites'].append(suite_data)
    
    # Add totals
    for engine in all_engines:
        lang = engine_lang_map.get(engine, '')
        if lang and 'totals' in results[lang] and engine in results[lang]['totals']:
            stats = results[lang]['totals'][engine]
            passed = stats.get('passed', 0)
            total = stats.get('total', 0)
            success_rate = (passed / total * 100) if total > 0 else 0
            
            template_data['totals'].append({
                'value': f"{passed:>3}",
                'class': 'success-low' if passed == 0 else 'success-medium'
            })
            
            template_data['success_rates'].append({
                'value': f"{success_rate:>6.2f}%",
                'class': get_success_class_for_rate(success_rate)
            })
        else:
            template_data['totals'].append({
                'value': 'N/A',
                'class': 'na'
            })
            template_data['success_rates'].append({
                'value': 'N/A',
                'class': 'na'
            })
    
    return template_data

def get_success_class(passed: int, total: int) -> str:
    if total == 0:
        return 'na'
    
    rate = (passed / total) * 100
    return get_success_class_for_rate(rate)

def get_success_class_for_rate(rate: float) -> str:
    if rate == 100:
        return 'success-high'    # Green for 100%
    elif rate > 0:
        return 'success-medium'  # Yellow for partial
    return 'success-low'        # Amber for 0%

def generate_html_report(template_data: Dict[str, Any]) -> str:
    # Set up Jinja2 environment
    template_dir = os.path.join(os.path.dirname(__file__), './templates')
    env = Environment(loader=FileSystemLoader(template_dir))
    
    # Load the template
    template = env.get_template('report.html.j2')
    
    # Render the template with our data
    return template.render(**template_data)

def main():
    results_dir = os.path.join(os.path.dirname(__file__), '..', 'results')
    results = load_results(results_dir)
    
    template_data = create_summary_table(results)
    
    # Generate and save HTML report
    html = generate_html_report(template_data)
    docs_dir = os.path.join(os.path.dirname(__file__), '..', 'docs')
    report_path = os.path.join(docs_dir, 'index.html')
    with open(report_path, 'w') as f:
        f.write(html)
    
    # Copy CSS file to docs directory
    css_src = os.path.join(os.path.dirname(__file__), './templates', 'styles.css')
    css_dest = os.path.join(docs_dir, 'styles.css')
    shutil.copy2(css_src, css_dest)
    
    print(f"Report generated: {report_path}")

if __name__ == "__main__":
    main()