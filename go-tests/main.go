package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"jsonlogic-tests/engines"
	"jsonlogic-tests/reporting"
	"jsonlogic-tests/test"
	"jsonlogic-tests/types"
	"os"
	"path/filepath"
)

func main() {
	suites, err := loadTestSuites()
	if err != nil {
		fmt.Printf("Error loading test suites: %v\n", err)
		os.Exit(1)
	}

	fmt.Printf("Successfully loaded %d test suites\n", len(suites))

	summary := reporting.NewTestSummary()
	for name, suite := range suites {
		runSuiteTests(summary, name, suite)
	}

	summary.PrintSummary()
	if err := summary.SaveJSON("../results/go.json"); err != nil {
		fmt.Printf("Error saving results: %v\n", err)
	}
}

func loadTestSuites() (map[string][]json.RawMessage, error) {
	indexContent, err := ioutil.ReadFile("../suites/index.json")
	if err != nil {
		return nil, err
	}

	var files []string
	if err := json.Unmarshal(indexContent, &files); err != nil {
		return nil, err
	}

	suites := make(map[string][]json.RawMessage)
	for _, file := range files {
		content, err := ioutil.ReadFile(filepath.Join("../suites", file))
		if err != nil {
			return nil, err
		}

		var suite []json.RawMessage
		if err := json.Unmarshal(content, &suite); err != nil {
			return nil, err
		}

		suites[file] = suite
	}

	return suites, nil
}

func runSuiteTests(summary *reporting.TestSummary, suiteName string, suite []json.RawMessage) {
	fmt.Printf("\nRunning suite: %s\n", suiteName)

	for _, engine := range types.AllEngines() {
		passed, total := runEngineTests(engine, suite)
		summary.AddResult(suiteName, engine, passed, total)
	}
}

func runEngineTests(engine types.JsonLogicEngine, suite []json.RawMessage) (passed, total int) {
	runner := engines.NewTestRunner(engine)

	for _, testCase := range suite {
		// Skip non-object test cases (like comments)
		if !isJSONObject(testCase) {
			continue
		}

		total++
		tc := &test.TestCase{}
		if err := json.Unmarshal(testCase, tc); err != nil {
			fmt.Printf("Error unmarshaling test case: %v\n", err)
			continue
		}

		if err := runner.RunTest(tc); err != nil {
			fmt.Printf("Test failed for %v: %v\n", engine, err)
		} else {
			passed++
		}
	}

	return passed, total
}

func isJSONObject(data json.RawMessage) bool {
	var obj map[string]interface{}
	return json.Unmarshal(data, &obj) == nil
}
