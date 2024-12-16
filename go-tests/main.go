package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"os"
	"path/filepath"
	"reflect"
	"strings"

	huanteng "github.com/HuanTeng/go-jsonlogic"
	"github.com/cucumber/godog"
	diegoholiveira "github.com/diegoholiveira/jsonlogic/v3"
)

type CucumberReport struct {
	Description string              `json:"description"`
	Elements    []CucumberScenario  `json:"elements"`
	ID          string              `json:"id"`
	Keyword     string              `json:"keyword"`
	Name        string              `json:"name"`
	Tags        []map[string]string `json:"tags"`
	URI         string              `json:"uri"`
}

type CucumberScenario struct {
	Description string              `json:"description"`
	ID          string              `json:"id"`
	Keyword     string              `json:"keyword"`
	Line        int                 `json:"line"`
	Name        string              `json:"name"`
	Steps       []CucumberStep      `json:"steps"`
	Tags        []map[string]string `json:"tags"`
	Type        string              `json:"type"`
}

type CucumberStep struct {
	Keyword string                 `json:"keyword"`
	Line    int                    `json:"line"`
	Name    string                 `json:"name"`
	Result  map[string]interface{} `json:"result"`
	Match   map[string]string      `json:"match"`
}

// Test context for scenario execution
type TestContext struct {
	currentLib string
	rules      string
	data       string
	result     interface{}
	scenarioID string
}

// Stats for test execution
type TestStats struct {
	Library string `json:"library"`
	Total   int    `json:"total"`
	Passed  int    `json:"passed"`
	Failed  int    `json:"failed"`
	Skipped int    `json:"skipped"`
}

func cleanJSONString(input string) string {
	input = strings.Trim(input, "'")
	return strings.ReplaceAll(input, "\\\"", "\"")
}

func (t *TestContext) iHaveTheRule(rule string) error {
	cleanRule := cleanJSONString(rule)
	var jsonRule interface{}
	if err := json.Unmarshal([]byte(cleanRule), &jsonRule); err != nil {
		return fmt.Errorf("invalid JSON rule: %v", err)
	}
	t.rules = cleanRule
	return nil
}

func (t *TestContext) iHaveTheDocument(doc string) error {
	cleanDoc := cleanJSONString(doc)
	var jsonData interface{}
	if err := json.Unmarshal([]byte(cleanDoc), &jsonData); err != nil {
		return fmt.Errorf("invalid JSON data: %v", err)
	}
	t.data = cleanDoc
	return nil
}

func (t *TestContext) whenIRunTheRule() error {
	var err error
	switch t.currentLib {
	case "diegoholiveira":
		// diegoholiveira/jsonlogic implementation
		rulesReader := bytes.NewReader([]byte(t.rules))
		dataReader := bytes.NewReader([]byte(t.data))
		var resultBuffer bytes.Buffer

		if err = diegoholiveira.Apply(rulesReader, dataReader, &resultBuffer); err != nil {
			return err
		}

		err = json.Unmarshal(resultBuffer.Bytes(), &t.result)
	case "huanteng":
		var rules, data interface{}
		if err = json.Unmarshal([]byte(t.rules), &rules); err != nil {
			return fmt.Errorf("failed to parse rules: %v", err)
		}
		if err = json.Unmarshal([]byte(t.data), &data); err != nil {
			return fmt.Errorf("failed to parse data: %v", err)
		}

		logic := huanteng.NewJSONLogic()
		t.result, err = logic.Apply(rules, data)
		if err != nil {
			return fmt.Errorf("failed to apply rules: %v", err)
		}
	}
	return err
}

func (t *TestContext) theResultShouldBe(expected string) error {
	cleanExpected := cleanJSONString(expected)
	var expectedValue interface{}
	if err := json.Unmarshal([]byte(cleanExpected), &expectedValue); err != nil {
		return fmt.Errorf("failed to parse expected value: %v", err)
	}

	if !reflect.DeepEqual(t.result, expectedValue) {
		return fmt.Errorf("expected %v but got %v", expectedValue, t.result)
	}
	return nil
}

func InitializeScenario(ctx *godog.ScenarioContext, lib string) {
	// Create single test context instance
	testCtx := &TestContext{currentLib: lib}

	// Register steps before any scenario execution
	ctx.Step(`^the rule ['"](.+)['"]$`, func(rule string) error {
		return testCtx.iHaveTheRule(rule)
	})

	ctx.Step(`^the data ['"](.+)['"]$`, func(doc string) error {
		return testCtx.iHaveTheDocument(doc)
	})

	ctx.Step(`^I evaluate the rule$`, func() error {
		return testCtx.whenIRunTheRule()
	})

	ctx.Step(`^the result should be ['"](.+)['"]$`, func(expected string) error {
		return testCtx.theResultShouldBe(expected)
	})

	// Add scenario hooks
	ctx.BeforeScenario(func(sc *godog.Scenario) {})

	ctx.AfterScenario(func(sc *godog.Scenario, err error) {})

	ctx.AfterStep(func(step *godog.Step, err error) {})
}

func runTests(library string) ([]*CucumberReport, error) {
	// Initialize features map
	features := make(map[string]*CucumberReport)
	featureFiles := []string{"compound_tests", "data-driven", "non-rules_get_passed_through", "single_operator_tests"}

	// Run tests for each feature file separately
	for _, feature := range featureFiles {
		featurePath := fmt.Sprintf("../features/%s.feature", feature)
		if _, err := os.Stat(featurePath); os.IsNotExist(err) {
			fmt.Printf("Warning: Feature file not found: %s\n", featurePath)
			continue
		}

		var buf bytes.Buffer
		opts := godog.Options{
			Format: "cucumber",
			Paths:  []string{featurePath}, // Run single feature
			Output: &buf,
		}

		suite := godog.TestSuite{
			Name: fmt.Sprintf("JsonLogic - %s - %s", library, feature),
			ScenarioInitializer: func(ctx *godog.ScenarioContext) {
				InitializeScenario(ctx, library) // Pass library name here
			},
			Options: &opts,
		}

		if status := suite.Run(); status != 0 {
			fmt.Printf("Warning: Tests failed for feature %s\n", feature)
		}

		// Parse results for this feature
		var results []CucumberReport
		if err := json.NewDecoder(&buf).Decode(&results); err != nil {
			return nil, fmt.Errorf("failed to parse test results for %s: %v", feature, err)
		}

		if len(results) > 0 {
			features[feature] = &results[0]
		} else {
			fmt.Printf("Warning: No results for feature %s\n", feature)
		}
	}

	// Convert map to slice
	var reports []*CucumberReport
	for _, report := range features {
		reports = append(reports, report)
	}

	return reports, nil
}

func generateReport(reports []*CucumberReport, library string) error {
	data, err := json.MarshalIndent(reports, "", "  ")
	if err != nil {
		return err
	}

	reportPath := filepath.Join("../reports", fmt.Sprintf("%s.json", library))
	return os.WriteFile(reportPath, data, 0644)
}

func main() {
	libraries := []string{"diegoholiveira", "huanteng"}

	for _, lib := range libraries {
		reports, err := runTests(lib)
		if err != nil {
			fmt.Printf("Error running %s tests: %v\n", lib, err)
			continue
		}

		if err := generateReport(reports, lib); err != nil {
			fmt.Printf("Error generating report for %s: %v\n", lib, err)
		}
	}
}
