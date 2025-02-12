package test

import "encoding/json"

type TestCase struct {
	Logic         json.RawMessage `json:"rule"`
	Data          json.RawMessage `json:"data"`
	ExpectedValue json.RawMessage `json:"result"`
	ExpectedError json.RawMessage `json:"error"`
}
