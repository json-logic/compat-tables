package types

type JsonLogicEngine int

const (
	DiegoHOliveira JsonLogicEngine = iota
	HuanTeng
)

func (e JsonLogicEngine) String() string {
	return [...]string{
		"DiegoHOliveira",
		"HuanTeng",
	}[e]
}

func AllEngines() []JsonLogicEngine {
	return []JsonLogicEngine{
		DiegoHOliveira,
		HuanTeng,
	}
}

type EngineResults struct {
	Passed int
	Total  int
}

func (r *EngineResults) SuccessRate() float64 {
	if r.Total == 0 {
		return 0.0
	}
	return float64(r.Passed) / float64(r.Total) * 100
}
