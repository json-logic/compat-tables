package jsonlogic.reporting;

import com.fasterxml.jackson.databind.ObjectMapper;
import java.io.File;
import java.util.HashMap;
import java.util.Map;

public class TestSummary {
    private final Map<String, Map<String, Map<String, Object>>> resultsBySuite;
    private final Map<String, Map<String, Object>> totals;

    public TestSummary() {
        this.resultsBySuite = new HashMap<>();
        this.totals = new HashMap<>();
    }

    public void addResult(String suiteName, String engine, int passed, int total) {
        // Initialize suite results if not exists
        resultsBySuite.putIfAbsent(suiteName, new HashMap<>());
        
        // Add suite result
        Map<String, Object> stats = new HashMap<>();
        stats.put("passed", passed);
        stats.put("total", total);
        stats.put("success_rate", total > 0 ? (passed * 100.0 / total) : 0.0);
        
        resultsBySuite.get(suiteName).put(engine, stats);

        // Update totals
        totals.putIfAbsent(engine, new HashMap<>());
        Map<String, Object> engineTotal = totals.get(engine);
        
        int totalPassed = (int) engineTotal.getOrDefault("passed", 0) + passed;
        int totalTotal = (int) engineTotal.getOrDefault("total", 0) + total;
        
        engineTotal.put("passed", totalPassed);
        engineTotal.put("total", totalTotal);
        engineTotal.put("success_rate", totalTotal > 0 ? (totalPassed * 100.0 / totalTotal) : 0.0);
    }

    public void saveJson(String filename) throws Exception {
        Map<String, Object> result = new HashMap<>();
        result.put("test_suites", resultsBySuite);
        result.put("totals", totals);
        result.put("timestamp", java.time.Instant.now().toString());

        new ObjectMapper().writerWithDefaultPrettyPrinter()
                        .writeValue(new File(filename), result);
    }
}