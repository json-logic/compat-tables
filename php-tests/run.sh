# run.sh
#!/bin/bash

# Install dependencies
composer install

cp ../features/*.feature features/

LIBRARIES=("jwadhams/json-logic-php")

# Run tests for each library
for lib in "${LIBRARIES[@]}"; do
    echo "Testing $lib..."
    export JSONLOGIC_LIBRARY="$lib"
    
    LIB_NAME=$(basename "$lib")
    JSON_OUTPUT="../reports/php-${LIB_NAME}.json"

    # Run behat with library-specific output
    vendor/bin/behat -f cucumber_json --out "../reports/"
    mv "../reports/default.json" $JSON_OUTPUT
done

# Generate version information
(
    echo "["
    for i in "${!LIBRARIES[@]}"; do
        lib=${LIBRARIES[$i]}
        LIB_NAME=$(basename "$lib")
        version=$(composer show $lib | grep 'versions' | grep -o '[0-9]*\.[0-9]*\.[0-9]*' | head -1)
        date=$(composer show $lib --format=json | jq -r '.released')
        echo "{\"library\": \"$LIB_NAME\", \"version\": \"$version\", \"date\": \"$date\"}"
        if [ $i -lt $((${#LIBRARIES[@]}-1)) ]; then
            echo ','
        fi
    done
    echo "]"
) | jq '.' > version.json