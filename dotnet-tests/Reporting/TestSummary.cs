using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace JsonLogic.Tests.Reporting;

public class TestSummary
{
    private readonly Dictionary<string, Dictionary<string, ResultStats>> _testSuites = new();
    private readonly Dictionary<string, ResultStats> _totals = new();
    private DateTime _timestamp;

    public class ResultStats
    {
        [JsonProperty("total")]
        public int Total { get; set; }

        [JsonProperty("passed")]
        public int Passed { get; set; }

        [JsonProperty("success_rate")]
        public double SuccessRate => Total == 0 ? 0 : (double)Passed / Total * 100;
    }

    public void AddResult(string suite, string engine, int passed, int failed)
    {
        if (!_testSuites.ContainsKey(suite))
            _testSuites[suite] = new Dictionary<string, ResultStats>();

        var stats = new ResultStats 
        { 
            Passed = passed,
            Total = passed + failed
        };
        
        _testSuites[suite][engine] = stats;

        // Update totals
        if (!_totals.ContainsKey(engine))
            _totals[engine] = new ResultStats();

        _totals[engine].Passed += passed;
        _totals[engine].Total += (passed + failed);

        _timestamp = DateTime.UtcNow;
    }

    public async Task SaveJsonAsync(string path)
    {
        var result = new JObject
        {
            ["test_suites"] = JObject.FromObject(_testSuites),
            ["totals"] = JObject.FromObject(_totals),
            ["timestamp"] = _timestamp.ToString("yyyy-MM-ddTHH:mm:ss.ffffffZ")
        };

        var settings = new JsonSerializerSettings 
        { 
            Formatting = Formatting.Indented,
            NullValueHandling = NullValueHandling.Ignore
        };
        
        await File.WriteAllTextAsync(path, result.ToString(Formatting.Indented));
    }
}