package engines

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"jsonlogic-tests/test"
	"jsonlogic-tests/types"
	"math"
	"strings"

	huantengjsonlogic "github.com/HuanTeng/go-jsonlogic"
	diegojsonlogic "github.com/diegoholiveira/jsonlogic/v3"
)

type TestRunner struct {
	engine types.JsonLogicEngine
}

func NewTestRunner(engine types.JsonLogicEngine) *TestRunner {
	return &TestRunner{engine: engine}
}

func (r *TestRunner) RunTest(tc *test.TestCase) error {
	var result json.RawMessage
	var err error

	switch r.engine {
	case types.DiegoHOliveira:
		result, err = r.runDiegoHOliveira(tc)
	case types.HuanTeng:
		result, err = r.runHuanTeng(tc)
	}

	if err != nil {
		if tc.ExpectedError != nil {
			return r.compareErrors(err.Error(), tc.ExpectedError)
		}
		return err
	}

	if tc.ExpectedError != nil {
		return fmt.Errorf("expected error but got result: %s", result)
	}

	return r.compareValues(result, tc.ExpectedValue)
}

func (r *TestRunner) runDiegoHOliveira(tc *test.TestCase) (json.RawMessage, error) {
	// Create buffer for result
	var result bytes.Buffer

	// Handle empty or null data
	dataJSON := []byte("null")
	if len(tc.Data) > 0 {
		dataJSON = tc.Data
	}

	// Create readers
	ruleReader := bytes.NewReader(tc.Logic)
	dataReader := bytes.NewReader(dataJSON)

	// Apply the rule
	if err := diegojsonlogic.Apply(ruleReader, dataReader, &result); err != nil {
		if err == io.EOF && result.Len() == 0 {
			return json.RawMessage(`null`), nil
		}
		return nil, fmt.Errorf("apply error: %v", err)
	}

	// If result is empty, return null
	if result.Len() == 0 {
		return json.RawMessage(`null`), nil
	}

	return result.Bytes(), nil
}

func (r *TestRunner) runHuanTeng(tc *test.TestCase) (json.RawMessage, error) {
	// Check for empty input
	if len(tc.Logic) == 0 {
		return json.RawMessage(`null`), nil
	}

	var rule, data interface{}

	// Parse rule with better error handling
	if err := json.Unmarshal(tc.Logic, &rule); err != nil {
		return nil, fmt.Errorf("invalid rule JSON: %v", err)
	}

	// Handle null or empty data
	if len(tc.Data) == 0 {
		data = nil
	} else if err := json.Unmarshal(tc.Data, &data); err != nil {
		return nil, fmt.Errorf("invalid data JSON: %v", err)
	}

	// Create new logic instance
	logic := huantengjsonlogic.NewJSONLogic()

	// Apply rule with error wrapping
	result, err := logic.Apply(rule, data)
	if err != nil {
		return nil, fmt.Errorf("rule application error: %v", err)
	}

	// Handle nil result
	if result == nil {
		return json.RawMessage(`null`), nil
	}

	// Marshal with error checking
	resultJSON, err := json.Marshal(result)
	if err != nil {
		return nil, fmt.Errorf("result marshaling error: %v", err)
	}

	return resultJSON, nil
}

func (r *TestRunner) compareValues(got, expected json.RawMessage) error {
	var gotVal, expectedVal interface{}

	if err := json.Unmarshal(got, &gotVal); err != nil {
		return fmt.Errorf("error unmarshaling result: %v", err)
	}
	if err := json.Unmarshal(expected, &expectedVal); err != nil {
		return fmt.Errorf("error unmarshaling expected value: %v", err)
	}

	if equal, err := r.deepEqual(gotVal, expectedVal); err != nil {
		return err
	} else if !equal {
		return fmt.Errorf("value mismatch\nExpected: %s\nGot: %s", expected, got)
	}

	return nil
}

func (r *TestRunner) deepEqual(got, expected interface{}) (bool, error) {
	switch exp := expected.(type) {
	case float64:
		if g, ok := got.(float64); ok {
			return math.Abs(g-exp) < 1e-10, nil
		}
	case []interface{}:
		if g, ok := got.([]interface{}); ok {
			if len(g) != len(exp) {
				return false, nil
			}
			for i := range exp {
				if equal, err := r.deepEqual(g[i], exp[i]); err != nil || !equal {
					return false, err
				}
			}
			return true, nil
		}
	case map[string]interface{}:
		if g, ok := got.(map[string]interface{}); ok {
			if len(g) != len(exp) {
				return false, nil
			}
			for k, v := range exp {
				gv, ok := g[k]
				if !ok {
					return false, nil
				}
				if equal, err := r.deepEqual(gv, v); err != nil || !equal {
					return false, err
				}
			}
			return true, nil
		}
	default:
		return got == expected, nil
	}
	return false, nil
}

func (r *TestRunner) compareErrors(got string, expected json.RawMessage) error {
	var expectedErr map[string]interface{}
	if err := json.Unmarshal(expected, &expectedErr); err != nil {
		return fmt.Errorf("error unmarshaling expected error: %v", err)
	}

	expectedType, ok := expectedErr["type"].(string)
	if !ok {
		return fmt.Errorf("expected error type not found")
	}

	// Try to parse got as JSON first
	var gotErr map[string]interface{}
	if err := json.Unmarshal([]byte(got), &gotErr); err == nil {
		if gotType, ok := gotErr["type"].(string); ok {
			if r.normalizeError(gotType) == r.normalizeError(expectedType) {
				return nil
			}
		}
	}

	// Fallback to string comparison
	if r.normalizeError(got) == r.normalizeError(expectedType) {
		return nil
	}

	return fmt.Errorf("error type mismatch\nExpected: %s\nGot: %s", expectedType, got)
}

func (r *TestRunner) normalizeError(err string) string {
	return strings.ToLower(strings.TrimSpace(strings.Trim(err, `"`)))
}
