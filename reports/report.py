import json
import os
from typing import Dict, Any, Tuple, List
from datetime import datetime

def load_results(directory: str) -> Dict[str, Any]:
    results = {}
    for filename in os.listdir(directory):
        if not filename.endswith('.json'):
            continue
            
        language = filename.split('.')[0]
        with open(os.path.join(directory, filename), 'r') as f:
            results[language] = json.load(f)
    return results

def create_summary_table(results: Dict[str, Any]) -> Tuple[None, List[List[str]]]:
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

    # Create headers and rows
    rows = []
    
    # Create language header row
    lang_row = ['Test Suite']
    engine_row = ['']
    
    # Add language and engine names
    for lang, engines in sorted(engine_by_lang.items()):
        engines_sorted = sorted(engines)
        lang_width = len(engines_sorted)
        center_pos = lang_width // 2
        
        # Add language name centered over its engines
        lang_headers = [''] * lang_width
        lang_headers[center_pos] = lang.upper()
        lang_row.extend(lang_headers)
        
        # Add engine names
        engine_row.extend(engines_sorted)
    
    # Add header rows
    rows.append(lang_row)
    rows.append(engine_row)
    rows.append(['-' * 80])  # Separator line
    
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
        
        row = [f"{suite} ({total_cases} cases)".ljust(40)]  # Left-align suite name with case count
        for lang, engines in sorted(engine_by_lang.items()):
            for engine in sorted(engines):
                suite_results = results[lang].get('test_suites', {}).get(suite, {})
                if engine in suite_results:
                    stats = suite_results[engine]
                    passed = stats.get('passed', 0)
                    row.append(f"{passed:>3}")
                else:
                    row.append(f"{'N/A':>7}")
        rows.append(row)

    # Add separator before totals
    rows.append(['-' * 80])
    
    # Add totals row
    total_row = ['TOTAL'.ljust(30)]
    success_row = ['Success Rate'.ljust(30)]
    
    for lang, engines in sorted(engine_by_lang.items()):
        for engine in sorted(engines):
            if 'totals' in results[lang] and engine in results[lang]['totals']:
                stats = results[lang]['totals'][engine]
                passed = stats.get('passed', 0)
                total = stats.get('total', 0)
                success_rate = (passed / total * 100) if total > 0 else 0
                
                total_row.append(f"{passed:>3}")  # Only show passing tests
                success_row.append(f"{success_rate:>6.2f}%")
            else:
                total_row.append(f"{'N/A':>7}")
                success_row.append(f"{'N/A':>7}")
        
    rows.append(total_row)
    rows.append(success_row)

    return None, rows

def get_success_class(cell: str, current_row: list = None) -> str:
    if cell.strip() == 'N/A':
        return 'na'
    try:
        # Skip test suite name cells
        if '(' in cell and 'cases)' in cell:
            return ''
        
        # Handle percentage values in Success Rate row
        if '%' in cell:
            rate = float(cell.rstrip('%'))
            if rate == 100:
                return 'success-high'    # Green for 100%
            elif rate > 0:
                return 'success-medium'  # Yellow for partial
            return 'success-low'        # Amber for 0%
        
        # Handle numeric values in regular cells
        value = int(cell.strip())
        
        # If we have the current row and it contains test suite info
        if current_row and '(' in current_row[0] and 'cases)' in current_row[0]:
            total = int(current_row[0].split('(')[1].split()[0])
            rate = (value / total) * 100 if total > 0 else 0
            
            if rate == 100:
                return 'success-high'    # Green for 100%
            elif rate > 0:
                return 'success-medium'  # Yellow for partial
            return 'success-low'        # Amber for 0%
        
        # For totals row, only color non-zero values
        return 'success-low' if value == 0 else 'success-medium'
        
    except Exception as e:
        print(f"Error processing cell '{cell}': {e}")
        return ''

def generate_html_report(rows: list, results: Dict[str, Any]) -> str:
    current_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    
    # Create engine to language mapping
    engine_lang_map = {}
    for lang, lang_results in results.items():
        for suite_results in lang_results.get('test_suites', {}).values():
            for engine in suite_results.keys():
                engine_lang_map[engine] = lang

    ICONS = {
        'go': '<i class="devicon-go-original-wordmark"></i>',
        'python': '<i class="devicon-python-plain"></i>',
        'rust': '<i class="devicon-rust-original"></i>',
        'php': '<i class="devicon-php-plain"></i>',
        'javascript': '<i class="devicon-javascript-plain"></i>',
        'java': '<i class="devicon-java-plain"></i>',
        'csharp': '<i class="devicon-csharp-plain"></i>',
    }
    
    html = f"""
    <!DOCTYPE html>
    <html>
    <head>
        <title>JSON Logic Implementation Comparison</title>
        <style>
            body {{ font-family: -apple-system, system-ui, sans-serif; margin: 20px; }}
            table {{ border-collapse: collapse; width: 100%; }}
            th, td {{ 
                padding: 8px; 
                text-align: center;  /* Center align all cells by default */
            }}
            th {{ background-color: #f2f2f2; }}
            td {{ border-bottom: 1px solid #ddd; }}
            .left {{ text-align: left; }}  /* For test suite names */
            .total-row {{ font-weight: bold; border-top: 2px solid #000; }}
            .success-row {{ font-weight: bold; }}
            .header-row th {{ border-bottom: 2px solid #000; }}
            .language-icon {{ 
                width: 16px;
                height: 16px;
                vertical-align: middle;
                margin-left: 4px;
            }}
            .success-high {{ background-color: #98FB98; }}   /* Pale green for 100% */
            .success-medium {{ background-color: #FFD700; }} /* Gold for partial */
            .success-low {{ background-color: #FF8C00; }}    /* Dark orange for 0% */
            .na {{ background-color: #f2f2f2; }}            /* Light gray for N/A */
        </style>
        <link rel="stylesheet" type='text/css' href="https://cdn.jsdelivr.net/gh/devicons/devicon@latest/devicon.min.css" />
    </head>
    <body>
        <h1>JSON Logic Implementation Comparison</h1>
        <p>Generated on: {current_time}</p>
        <table>
    """

    # Add headers without language names
    lang_row, engine_row = rows[0], rows[1]
    html += "<tr class='header-row'>"
    html += f"<th rowspan='2'>{lang_row[0]}</th>"  # Test Suite column
    
    # Add engine names with language icons
    html += "<tr class='header-row'>"
    for cell in engine_row[1:]:  # Skip first empty cell
        if cell:
            # Get language from the mapping
            lang = engine_lang_map.get(cell, '').lower()
            if lang in ICONS:
                html += f"""<th>{cell} {ICONS[lang]}</th>"""
            else:
                html += f"<th>{cell}</th>"
    html += "</tr>\n"

    # Add data rows
    for row in rows[3:-3]:  # Skip headers and total rows
        html += "<tr>"
        for i, cell in enumerate(row):
            if i == 0:
                html += f"<td class='left'>{cell}</td>"
            else:
                success_class = get_success_class(cell, row)
                html += f"<td class='{success_class}'>{cell}</td>"
        html += "</tr>\n"

    # Add total rows
    for row in rows[-2:]:
        cls = 'total-row' if 'TOTAL' in row[0] else 'success-row'
        html += f"<tr class='{cls}'>"
        for i, cell in enumerate(row):
            if i == 0:
                html += f"<td class='left'>{cell}</td>"
            else:
                success_class = get_success_class(cell, row)
                html += f"<td class='{success_class}'>{cell}</td>"
        html += "</tr>\n"

    html += """
        </table>
    </body>
    </html>
    """
    return html

def main():
    results_dir = os.path.join(os.path.dirname(__file__), '..', 'results')
    results = load_results(results_dir)
    
    _, rows = create_summary_table(results)
    
    # Generate and save HTML report
    html = generate_html_report(rows, results)
    report_path = os.path.join(os.path.dirname(__file__), '..', 'docs', 'index.html')
    with open(report_path, 'w') as f:
        f.write(html)
    print(f"Report generated: {report_path}")

if __name__ == "__main__":
    main()