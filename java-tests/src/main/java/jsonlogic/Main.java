package jsonlogic;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import jsonlogic.engines.TestRunner;
import jsonlogic.test.TestCase;
import jsonlogic.reporting.TestSummary;

import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.ArrayList;

public class Main {
    public static void main(String[] args) {
        try {
            // Load test suites
            Map<String, List<TestCase>> suites = loadTestSuites();
            System.out.printf("Successfully loaded %d test suites%n", suites.size());

            TestSummary summary = new TestSummary();
            String[] engines = {"jamsesso"};

            // Run tests for each engine
            for (Map.Entry<String, List<TestCase>> entry : suites.entrySet()) {
                String name = entry.getKey();
                List<TestCase> suite = entry.getValue();
                
                System.out.printf("%nRunning suite: %s%n", name);
                
                for (String engine : engines) {
                    System.out.printf("%nTesting engine: %s%n", engine);
                    int[] results = runEngineSuite(engine, suite);
                    summary.addResult(name, engine, results[0], results[1]);
                }
            }

            // Save results
            String resultPath = "../results/java.json";
            summary.saveJson(resultPath);
            System.out.printf("%nReport generated: %s%n", resultPath);

        } catch (Exception e) {
            e.printStackTrace();
            System.exit(1);
        }
    }

    private static Map<String, List<TestCase>> loadTestSuites() throws Exception {
        ObjectMapper mapper = new ObjectMapper();
        Path indexPath = Paths.get("../suites/index.json");
        List<String> files = mapper.readValue(indexPath.toFile(), new com.fasterxml.jackson.core.type.TypeReference<List<String>>() {});
        
        Map<String, List<TestCase>> suites = new HashMap<>();
        Path suitesDir = Paths.get("../suites");
        
        for (String file : files) {
            Path filePath = suitesDir.resolve(file);
            JsonNode rootNode = mapper.readTree(filePath.toFile());
            if (rootNode.isArray()) {
                List<TestCase> testCases = new ArrayList<>();
                for (JsonNode node : rootNode) {
                    // Skip string nodes (titles/comments)
                    if (!node.isTextual() && node.isObject()) {
                        try {
                            TestCase testCase = mapper.convertValue(node, TestCase.class);
                            testCases.add(testCase);
                        } catch (Exception e) {
                            System.err.printf("Warning: Failed to parse test case in %s: %s%n", 
                                file, node.toString());
                        }
                    }
                }
                suites.put(file, testCases);
            }
        }
        
        return suites;
    }

    private static int[] runEngineSuite(String engine, List<TestCase> suite) {
        TestRunner runner = new TestRunner(engine);
        int passed = 0;
        int total = 0;

        for (TestCase testCase : suite) {
            total++;
            if (runner.runTest(testCase)) {
                passed++;
            }
        }

        if (total > 0) {
            double successRate = (passed * 100.0) / total;
            System.out.printf("%nResults: %d/%d passed (%.2f%%)%n", 
                passed, total, successRate);
        }

        return new int[]{passed, total};
    }
}