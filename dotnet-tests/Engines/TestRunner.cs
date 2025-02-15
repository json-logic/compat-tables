using JsonLogic.Net;
using JsonLogic.Tests.Models;
using System.Text.Json;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace JsonLogic.Tests.Engines;

public class TestRunner
{
    private readonly string _engine;
    private readonly JsonLogicEvaluator _evaluator;

    public TestRunner(string engine)
    {
        _engine = engine;
        _evaluator = new JsonLogicEvaluator(EvaluateOperators.Default);
    }

    public bool RunTest(TestCase testCase)
    {
        try
        {
            var result = ApplyRule(testCase.Logic, testCase.Data);

            if (testCase.ExpectedError != null)
            {
                Console.WriteLine("Expected error but got result");
                return false;
            }

            var matches = CompareValues(result, testCase.ExpectedValue);
            if (!matches)
            {
                Console.Error.WriteLine($"❌ Mismatch: Got {JsonConvert.SerializeObject(result)}, Expected {JsonConvert.SerializeObject(testCase.ExpectedValue)}");
                Console.Error.WriteLine($"Rule: {JsonConvert.SerializeObject(testCase.Logic)}");
                Console.Error.WriteLine($"Data: {JsonConvert.SerializeObject(testCase.Data)}");
            }
            return matches;
        }
        catch (Exception ex)
        {
            if (testCase.ExpectedError == null)
            {
                Console.Error.WriteLine($"❌ Unexpected error: {ex.Message}");
                Console.Error.WriteLine($"Rule: {JsonConvert.SerializeObject(testCase.Logic)}");
                Console.Error.WriteLine($"Data: {JsonConvert.SerializeObject(testCase.Data)}");
                Console.Error.WriteLine($"Stack trace: {ex.StackTrace}");
                return false;
            }
            return CompareErrors(ex.Message, testCase.ExpectedError);
        }
    }

    private object? ApplyRule(object? rule, object? data)
    {
        if (_engine != "jsonlogicnet")
            throw new ArgumentException($"Unknown engine: {_engine}");

        try
        {
            // Convert rule to JObject as required by the library
            var ruleJson = rule != null ? JObject.FromObject(rule) : null;
            if (ruleJson == null)
            {
                Console.WriteLine("Warning: Rule is null or cannot be converted to JObject");
                return null;
            }
            
            return _evaluator.Apply(ruleJson, data);
        }
        catch (Exception ex)
        {
            Console.Error.WriteLine($"Error in ApplyRule:");
            Console.Error.WriteLine($"Rule (raw): {rule}");
            Console.Error.WriteLine($"Data (raw): {data}");
            throw;
        }
    }

    private bool CompareValues(object? got, object? expected)
    {
        try
        {
            if (expected == null)
                return got == null;
    
            // Convert expected JToken to underlying value if needed
            if (expected is JToken jToken)
                expected = jToken.ToObject<object>();
    
            // Handle numeric comparisons
            if (got is double || got is float || got is int || got is long)
            {
                var gotDouble = Convert.ToDouble(got);
                var expectedDouble = Convert.ToDouble(expected);
                return Math.Abs(gotDouble - expectedDouble) < 1e-10;
            }
    
            // Handle boolean comparisons
            if (got is bool || expected is bool)
            {
                return Convert.ToBoolean(got) == Convert.ToBoolean(expected);
            }
    
            // Handle array comparisons
            if (got is System.Collections.IEnumerable gotEnum && expected is System.Collections.IEnumerable expEnum)
            {
                var gotList = gotEnum.Cast<object>().ToList();
                var expList = expEnum.Cast<object>().ToList();
    
                if (gotList.Count != expList.Count)
                    return false;
    
                for (int i = 0; i < gotList.Count; i++)
                {
                    if (!CompareValues(gotList[i], expList[i]))
                        return false;
                }
                return true;
            }
    
            // Handle string comparisons
            if (got?.ToString() == expected?.ToString())
                return true;
    
            Console.WriteLine($"Compare failed: Got type={got?.GetType().Name}, Expected type={expected?.GetType().Name}");
            Console.WriteLine($"Got value={got}, Expected value={expected}");
            return false;
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Error comparing values: {ex.Message}");
            Console.WriteLine($"Got: {got?.GetType().Name} = {got}");
            Console.WriteLine($"Expected: {expected?.GetType().Name} = {expected}");
            return false;
        }
    }

    private bool CompareErrors(string got, object? expected)
    {
        if (expected is not JsonElement errorObj)
            return false;

        string? expectedType = null;
        string? expectedMessage = null;

        if (errorObj.TryGetProperty("type", out var typeElement))
            expectedType = typeElement.GetString();
        if (errorObj.TryGetProperty("message", out var messageElement))
            expectedMessage = messageElement.GetString();

        var gotLower = got.ToLowerInvariant();
        return (expectedType == null || gotLower.Contains(expectedType.ToLowerInvariant())) &&
               (expectedMessage == null || gotLower.Contains(expectedMessage.ToLowerInvariant()));
    }

    private bool CompareJsonElements(JsonElement got, JsonElement expected)
    {
        if (got.ValueKind != expected.ValueKind)
            return false;

        return got.ValueKind switch
        {
            JsonValueKind.Number => Math.Abs(got.GetDouble() - expected.GetDouble()) < 1e-10,
            JsonValueKind.String => got.GetString() == expected.GetString(),
            JsonValueKind.True => true,
            JsonValueKind.False => false,
            JsonValueKind.Null => true,
            _ => got.GetRawText() == expected.GetRawText()
        };
    }
}