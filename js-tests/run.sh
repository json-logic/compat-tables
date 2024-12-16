npm install
npm run test:all

LIBRARIES=("json-logic-engine" "json-logic-js")

(
    echo "["
    for i in "${!LIBRARIES[@]}"; do
        version=$(npm view ${LIBRARIES[$i]} version)
        date=$(npm view ${LIBRARIES[$i]} time --json | node -e "process.stdin.on('data', function(data) {console.log(JSON.parse(data)['"$version"'])});")
        echo "{\"library\": \"${LIBRARIES[$i]}\", \"version\": \"$version\", \"date\": \"$date\"}"
        if [ $i -lt $((${#LIBRARIES[@]}-1)) ]; then
            echo ','
        fi
    done
    echo "]"
) | jq '.' > version.json