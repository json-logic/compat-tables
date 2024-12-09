npm install
npm test

lib="json-logic-engine"
> version.json
version=$(npm view $lib version)
date=$(npm view $lib time --json | node -e "process.stdin.on('data', function(data) {console.log(JSON.parse(data)['"$version"'])});")
echo "[{\"library\": \"$lib\", \"version\": \"$version\", \"date\": \"$date\"}]" >> version.json
