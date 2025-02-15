using JsonLogic.Tests.Models;
using JsonLogic.Tests.Engines;
using JsonLogic.Tests.Reporting;
using System.Text.Json;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace JsonLogic.Tests;

public class Program
{
    public static async Task Main(string[] args)
    {
        try
        {
            var suites = await LoadTestSuitesAsync();
            Console.WriteLine($"Successfully loaded {suites.Count} test suites");

            var engines = new[] { "jsonlogicnet" };
            var summary = new TestSummary();

            foreach (var (name, suite) in suites)
            {
                Console.WriteLine($"\nRunning suite: {name}");
                
                foreach (var engine in engines)
                {
                    Console.WriteLine($"\nTesting engine: {engine}");
                    var results = RunEngineSuite(engine, suite);
                    summary.AddResult(name, engine, results.passed, results.failed);
                }
            }

            var resultPath = "../results/csharp.json";
            await summary.SaveJsonAsync(resultPath);
            Console.WriteLine($"\nReport generated: {resultPath}");
        }
        catch (Exception ex)
        {
            Console.Error.WriteLine(ex);
            Environment.Exit(1);
        }
    }

    private static async Task<Dictionary<string, List<TestCase>>> LoadTestSuitesAsync()
    {
        var indexPath = Path.Combine("..", "suites", "index.json");
        var indexContent = await File.ReadAllTextAsync(indexPath);
        var files = JsonConvert.DeserializeObject<List<string>>(indexContent);
        
        var suites = new Dictionary<string, List<TestCase>>();
        var suitesDir = Path.Combine("..", "suites");
        
        foreach (var file in files ?? Enumerable.Empty<string>())
        {
            var filePath = Path.Combine(suitesDir, file);
            var content = await File.ReadAllTextAsync(filePath);
            var jsonArray = JArray.Parse(content);
            
            var testCases = new List<TestCase>();
            foreach (var item in jsonArray)
            {
                if (item.Type == JTokenType.Object)
                {
                    try
                    {
                        var testCase = item.ToObject<TestCase>();
                        if (testCase != null)
                        {
                            // Console.WriteLine($"\nParsed test case: {testCase.ToString()}");
                            testCases.Add(testCase);
                        }
                        else
                        {
                            Console.WriteLine($"Warning: Invalid test case - Logic is null");
                            Console.WriteLine($"Raw JSON: {item}");
                        }
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine($"Warning: Failed to parse test case in {file}:");
                        Console.WriteLine($"Raw JSON: {item}");
                        Console.WriteLine($"Error: {ex.Message}");
                        Console.WriteLine($"Stack trace: {ex.StackTrace}");
                    }
                }
                else
                {
                    Console.WriteLine($"Skipping non-object item: {item.Type} - {item}");
                }
            }
            
            suites[file] = testCases;
            Console.WriteLine($"Added {testCases.Count} test cases from {file}");
        }
        
        return suites;
    }

    private static (int passed, int failed) RunEngineSuite(string engine, List<TestCase> suite)
    {
        var runner = new TestRunner(engine);
        int passed = 0, failed = 0;

        foreach (var test in suite)
        {
            if (runner.RunTest(test))
                passed++;
            else
                failed++;
        }

        return (passed, failed);
    }
}