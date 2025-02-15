package jsonlogic.test;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;

@JsonIgnoreProperties(ignoreUnknown = true)
public class TestCase {
    @JsonProperty("description")
    private String description;

    @JsonProperty("rule")
    private Object logic;

    @JsonProperty("data")
    private Object data;

    @JsonProperty("result")
    private Object expectedValue;

    @JsonProperty("error")
    private Object expectedError;

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    // Getters and setters
    public Object getLogic() { return logic; }
    public void setLogic(Object logic) { this.logic = logic; }

    public Object getData() { return data; }
    public void setData(Object data) { this.data = data; }

    public Object getExpectedValue() { return expectedValue; }
    public void setExpectedValue(Object expectedValue) { this.expectedValue = expectedValue; }

    public Object getExpectedError() { return expectedError; }
    public void setExpectedError(Object expectedError) { this.expectedError = expectedError; }
}