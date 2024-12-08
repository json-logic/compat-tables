python3 test-data/convert.py test-data/test-cases.json features
cargo test --test rust-jsonlogic --release
cargo test --test rust-jsonlogic-rs --release
cargo test --test rust-datalogic-rs --release
cd js-json-logic-js
npm install
npm test
cd ../js-json-logic-engine
npm install
npm test
cd ../reports
python3 report.py