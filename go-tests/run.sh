#!/bin/bash

# Install dependencies
go get -u github.com/cucumber/godog/cmd/godog
go get -u github.com/diegoholiveira/jsonlogic
go get -u github.com/HuanTeng/go-jsonlogic

LIBRARIES=("diegoholiveira/jsonlogic/v3" "HuanTeng/go-jsonlogic")

# Run tests
go run main.go

# Function to get GitHub release date
get_release_date() {
    local full_path=$1
    local version=$2
    
    # Extract owner and repo
    local owner=$(echo $full_path | cut -d'/' -f1)
    local repo=$(echo $full_path | cut -d'/' -f2)
    
    # Query GitHub API
    local release_date=$(curl -s "https://api.github.com/repos/$owner/$repo/releases/tags/$version" | jq -r '.published_at // empty')
    
    # If no release date found, try commits
    if [ -z "$release_date" ]; then
        release_date=$(curl -s "https://api.github.com/repos/$owner/$repo/commits?per_page=1" | jq -r '.[0].commit.committer.date // empty')
    fi
    
    echo ${release_date:-$(date -u +"%Y-%m-%dT%H:%M:%S.000Z")}
}

# Generate version information
(
    echo "["
    for i in "${!LIBRARIES[@]}"; do
        lib_path=${LIBRARIES[$i]}
        version=$(go list -m github.com/${lib_path} | awk '{print $2}')
        date=$(get_release_date ${lib_path} ${version})
        echo "{\"library\": \"${lib_path}\", \"version\": \"$version\", \"date\": \"$date\"}"
        if [ $i -lt $((${#LIBRARIES[@]}-1)) ]; then
            echo ','
        fi
    done
    echo "]"
) | jq '.' > version.json