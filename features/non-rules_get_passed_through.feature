Feature: Non-rules get passed through

  Testing non-rules get passed through operations in JsonLogic

  Scenario: true
    Given the rule 'true'
    And the data '{}'
    When I evaluate the rule
    Then the result should be 'true'

  Scenario: false
    Given the rule 'false'
    And the data '{}'
    When I evaluate the rule
    Then the result should be 'false'

  Scenario: 17
    Given the rule '17'
    And the data '{}'
    When I evaluate the rule
    Then the result should be '17'

  Scenario: 3.14
    Given the rule '3.14'
    And the data '{}'
    When I evaluate the rule
    Then the result should be '3.14'

  Scenario: "apple"
    Given the rule '\"apple\"'
    And the data '{}'
    When I evaluate the rule
    Then the result should be '\"apple\"'

  Scenario: null
    Given the rule 'null'
    And the data '{}'
    When I evaluate the rule
    Then the result should be 'null'

  Scenario: ["a","b"]
    Given the rule '[\"a\", \"b\"]'
    And the data '{}'
    When I evaluate the rule
    Then the result should be '[\"a\", \"b\"]'
