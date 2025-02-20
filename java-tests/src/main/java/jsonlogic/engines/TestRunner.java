package jsonlogic.engines;

import com.fasterxml.jackson.databind.ObjectMapper;
import io.github.jamsesso.jsonlogic.JsonLogic;
import jsonlogic.test.TestCase;
import java.util.Map;

public class TestRunner {
    private final String engine;
    private final JsonLogic jamsessoEngine;
    private final ObjectMapper objectMapper;

    public TestRunner(String engine) {
        this.engine = engine;
        this.jamsessoEngine = new JsonLogic();
        this.objectMapper = new ObjectMapper();
    }

    public boolean runTest(TestCase testCase) {
        try {
            Object result = applyRule(testCase.getLogic(), testCase.getData());
            
            if (testCase.getExpectedError() != null) {
                return false;
            }
    
            return compareValues(result, testCase.getExpectedValue());
        } catch (Exception e) {
            if (testCase.getExpectedError() == null) {
                System.err.println("Unexpected error: " + e.getMessage());
                return false;
            }
            // Convert error message to string explicitly
            String errorMessage = e.getMessage() != null ? e.getMessage() : e.toString();
            return compareErrors(errorMessage, testCase.getExpectedError());
        }
    }

    private Object applyRule(Object rule, Object data) throws Exception {
        if ("jamsesso".equals(engine)) {
            try {
                // Convert rule to JSON string as required by the library
                String ruleString = objectMapper.writeValueAsString(rule);
                return jamsessoEngine.apply(ruleString, data);
            } catch (Exception e) {
                System.err.println("Error applying rule: " + e.getMessage());
                throw e;
            }
        }
        throw new RuntimeException("Unknown engine: " + engine);
    }

    private boolean compareValues(Object got, Object expected) {
        if (expected == null) {
            return got == null || Boolean.FALSE.equals(got) || 
                   Integer.valueOf(0).equals(got) || "".equals(got) || 
                   (got instanceof Object[] && ((Object[]) got).length == 0);
        }

        // Handle numeric comparisons
        if (got instanceof Number && expected instanceof Number) {
            double diff = ((Number) got).doubleValue() - ((Number) expected).doubleValue();
            return Math.abs(diff) < 1e-10;
        }

        // Handle array comparisons
        if (got instanceof Object[] && expected instanceof Object[]) {
            Object[] gotArray = (Object[]) got;
            Object[] expectedArray = (Object[]) expected;
            
            if (gotArray.length != expectedArray.length) {
                return false;
            }

            for (int i = 0; i < gotArray.length; i++) {
                if (!compareValues(gotArray[i], expectedArray[i])) {
                    return false;
                }
            }
            return true;
        }

        return got.equals(expected);
    }

    @SuppressWarnings("unchecked")
    private boolean compareErrors(String got, Object expected) {
        if (!(expected instanceof Map)) {
            return false;
        }
    
        Map<String, Object> errorMap = (Map<String, Object>) expected;
        Object typeObj = errorMap.get("type");
        Object messageObj = errorMap.get("message");

        String expectedType = typeObj != null ? typeObj.toString() : null;
        String expectedMessage = messageObj != null ? messageObj.toString() : null;
    
        String gotLower = got.toLowerCase();
        return (expectedType == null || gotLower.contains(expectedType.toLowerCase())) &&
               (expectedMessage == null || gotLower.contains(expectedMessage.toLowerCase()));
    }
}