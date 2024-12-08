Feature: JsonLogic Compound Tests

  Testing compound tests operations in JsonLogic

  Scenario: {"and":[{">":[3,1]},true]}
    Given the rule '{\"and\": [{\">\": [3, 1]}, true]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be 'true'

  Scenario: {"and":[{">":[3,1]},false]}
    Given the rule '{\"and\": [{\">\": [3, 1]}, false]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be 'false'

  Scenario: {"and":[{">":[3,1]},{"!":true}]}
    Given the rule '{\"and\": [{\">\": [3, 1]}, {\"!\": true}]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be 'false'

  Scenario: {"and":[{">":[3,1]},{"<":[1,3]}]}
    Given the rule '{\"and\": [{\">\": [3, 1]}, {\"<\": [1, 3]}]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be 'true'

  Scenario: {"?:":[{">":[3,1]},"visible","hidden"]}
    Given the rule '{\"?:\": [{\">\": [3, 1]}, \"visible\", \"hidden\"]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be '\"visible\"'
