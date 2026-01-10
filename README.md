# JSON Logic Compatibility Tables

This repository contains compatibility test results for various JSON Logic implementations across different programming languages.

View the compatibility matrix: https://json-logic.github.io/compat-tables/

## Running the Tests

The test results are stored in the `results` directory as JSON files, one for each language implementation.

## Generating the Report

To generate the HTML compatibility report:

1. Create a virtual environment:
   ```bash
   python3 -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

2. Install the dependencies:
   ```bash
   pip install -r requirements.txt
   ```

3. Run the report generation script:
   ```bash
   python reports/report.py
   ```

4. The report will be generated in the `docs` directory as `index.html`.

## Report Structure

The report shows a compatibility matrix of different JSON Logic implementations across various programming languages. Each cell shows the number of tests passed for a particular test suite and implementation.

The color coding indicates:
- 🔵 Cyan: Full Support (100% of tests passed)
- 🩷 Pink: Partial Support (some tests passed)
- 🟣 Purple: No Support (no tests passed)
