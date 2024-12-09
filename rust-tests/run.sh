#!/bin/bash

# Define libraries to check
LIBRARIES=("jsonlogic" "jsonlogic-rs" "datalogic-rs")

get_local_version() {
    local crate_name=$1
    cargo metadata --format-version 1 | \
        jq -r --arg name "$crate_name" \
        '.packages[] | select(.name == $name) | .version'
}

get_crate_info() {
    local crate_name=$1
    local crate_version=$2
    local date=$(curl -s "https://crates.io/api/v1/crates/$crate_name/versions" | \
                jq -r --arg version "$crate_version" \
                '.versions[] | select(.num == $version) | .created_at' | \
                cut -d'T' -f1)
    echo "{ \"library\": \"$crate_name\", \"version\": \"$crate_version\", \"date\": \"$date\" }"
}

# Run tests for each library
for lib in "${LIBRARIES[@]}"; do
    cargo test --test "rust-$lib" --release
done

# Generate version info
(
    echo '['
    for i in "${!LIBRARIES[@]}"; do
        get_crate_info "${LIBRARIES[$i]}" "$(get_local_version "${LIBRARIES[$i]}")"
        # Add comma for all except last element
        if [ $i -lt $((${#LIBRARIES[@]}-1)) ]; then
            echo ','
        fi
    done
    echo ']'
) | jq '.' > version.json