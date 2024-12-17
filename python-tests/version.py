import json
import subprocess
import argparse
import requests
from datetime import datetime

def get_pip_info(package):
    try:
        result = subprocess.run(['pip', 'show', package], 
                              capture_output=True, text=True)
        info = {}
        for line in result.stdout.split('\n'):
            if ':' in line:
                key, value = line.split(':', 1)
                info[key.strip()] = value.strip()
        return info
    except Exception:
        return {}

def get_pypi_info(package):
    try:
        response = requests.get(f"https://pypi.org/pypi/{package}/json")
        if response.status_code == 200:
            data = response.json()
            version = data['info']['version']
            # Get release date for current version
            release_date = data['releases'][version][0]['upload_time'][:10]
            return {
                'Version': version,
                'Release-Date': release_date
            }
    except Exception as e:
        print(f"Error fetching PyPI info for {package}: {e}")
    return {}

def main():
    parser = argparse.ArgumentParser(description='Generate version info for JSON Logic libraries')
    parser.add_argument('libraries', 
                       help='Comma-separated list of libraries (e.g., json-logic-py,json-logic-qubit)')
    args = parser.parse_args()

    libraries = [lib.strip() for lib in args.libraries.split(',')]
    version_info = []

    for library in libraries:
        pip_info = get_pip_info(library)
        pypi_info = get_pypi_info(library)
        
        version_info.append({
            "library": library,
            "version": pip_info.get('Version', pypi_info.get('Version', 'unknown')),
            "date": pypi_info.get('Release-Date', datetime.now().strftime('%Y-%m-%d'))
        })

    print(json.dumps(version_info, indent=2))

if __name__ == '__main__':
    main()