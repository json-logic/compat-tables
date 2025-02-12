package reporting

import (
	"encoding/json"
	"fmt"
	"os"
	"runtime"
	"sort"
	"strings"
	"time"

	"jsonlogic-tests/types"
)

type EngineStats struct {
	Passed int `json:"passed"`
	Total  int `json:"total"`
}

func NewEngineStats(passed, total int) *EngineStats {
	return &EngineStats{
		Passed: passed,
		Total:  total,
	}
}

type SuiteResults map[types.JsonLogicEngine]*EngineStats

type TestSummary struct {
	resultsBySuite map[string]SuiteResults
	totals         map[types.JsonLogicEngine]*EngineStats
}

func NewTestSummary() *TestSummary {
	return &TestSummary{
		resultsBySuite: make(map[string]SuiteResults),
		totals:         make(map[types.JsonLogicEngine]*EngineStats),
	}
}

func (s *TestSummary) AddResult(suiteName string, engine types.JsonLogicEngine, passed, total int) {
	// Initialize suite results if not exists
	if _, ok := s.resultsBySuite[suiteName]; !ok {
		s.resultsBySuite[suiteName] = make(SuiteResults)
	}

	// Add suite result
	s.resultsBySuite[suiteName][engine] = NewEngineStats(passed, total)

	// Update totals
	if _, ok := s.totals[engine]; !ok {
		s.totals[engine] = NewEngineStats(0, 0)
	}

	totalStats := s.totals[engine]
	totalStats.Passed += passed
	totalStats.Total += total
}

func (s *TestSummary) PrintSummary() {
	fmt.Printf("\n%s\n", centerText(" Test Results Summary ", 80, "="))

	// Print header
	fmt.Printf("%-30s", "Test Suite")
	for _, engine := range types.AllEngines() {
		fmt.Printf("%15s", engine)
	}
	fmt.Printf("\n%s\n", strings.Repeat("-", 80))

	// Print results for each suite
	suiteNames := make([]string, 0, len(s.resultsBySuite))
	for name := range s.resultsBySuite {
		suiteNames = append(suiteNames, name)
	}
	sort.Strings(suiteNames)

	for _, suiteName := range suiteNames {
		fmt.Printf("%-30s", suiteName)
		for _, engine := range types.AllEngines() {
			if result, ok := s.resultsBySuite[suiteName][engine]; ok {
				fmt.Printf("%7d/%-7d", result.Passed, result.Total)
			} else {
				fmt.Printf("%15s", "N/A")
			}
		}
		fmt.Println()
	}

	// Print totals
	fmt.Printf("%s\n", strings.Repeat("-", 80))
	fmt.Printf("%-30s", "TOTAL")
	for _, engine := range types.AllEngines() {
		if total, ok := s.totals[engine]; ok {
			fmt.Printf("%7d/%-7d", total.Passed, total.Total)
		} else {
			fmt.Printf("%15s", "N/A")
		}
	}
	fmt.Println()

	// Print success rates
	fmt.Printf("%-30s", "Success Rate")
	for _, engine := range types.AllEngines() {
		if total, ok := s.totals[engine]; ok {
			fmt.Printf("%14.2f%%", float64(total.Passed)/float64(total.Total)*100)
		} else {
			fmt.Printf("%15s", "N/A")
		}
	}
	fmt.Println()
}

func (s *TestSummary) SaveJSON(filename string) error {
	type jsonResult struct {
		TestSuites map[string]map[string]*EngineStats `json:"test_suites"`
		Totals     map[string]*EngineStats            `json:"totals"`
		Timestamp  string                             `json:"timestamp"`
		GoVersion  string                             `json:"go_version"`
	}

	result := jsonResult{
		TestSuites: make(map[string]map[string]*EngineStats),
		Totals:     make(map[string]*EngineStats),
		Timestamp:  time.Now().UTC().Format(time.RFC3339),
		GoVersion:  runtime.Version(),
	}

	// Convert suite results
	for suite, results := range s.resultsBySuite {
		suiteMap := make(map[string]*EngineStats)
		for engine, stats := range results {
			suiteMap[engine.String()] = stats
		}
		result.TestSuites[suite] = suiteMap
	}

	// Convert totals
	for engine, stats := range s.totals {
		result.Totals[engine.String()] = stats
	}

	// Marshal with indentation
	data, err := json.MarshalIndent(result, "", "  ")
	if err != nil {
		return err
	}

	return os.WriteFile(filename, data, 0644)
}

func centerText(text string, width int, fill string) string {
	if len(text) >= width {
		return text
	}

	leftPad := (width - len(text)) / 2
	rightPad := width - len(text) - leftPad

	return strings.Repeat(fill, leftPad) + text + strings.Repeat(fill, rightPad)
}
