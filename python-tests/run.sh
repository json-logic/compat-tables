#!/bin/bash

# Install dependencies
pip install -r requirements.txt

cp ../features/*.feature features/

LIBRARIES=("json-logic-qubit" "panzi-json-logic" "python-jsonlogic")

# Run tests
for lib in "${LIBRARIES[@]}"; do
    echo "Testing $lib..."
    export JSONLOGIC_LIBRARY="$lib"
    
    # Run behave with library-specific output
    behave features/ -f json.pretty -o "../reports/python-${lib}.json"
done


# Generate version info
LIBRARIES_STRING=$(IFS=,; echo "${LIBRARIES[*]}")
python3 version.py "$LIBRARIES_STRING" > version.json
