Feature: Single operator tests

  Testing single operator tests operations in JsonLogic

  Scenario: {"==":[1,1]}
    Given the rule '{\"==\": [1, 1]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be 'true'

  Scenario: {"==":[1,"1"]}
    Given the rule '{\"==\": [1, \"1\"]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be 'true'

  Scenario: {"==":[1,2]}
    Given the rule '{\"==\": [1, 2]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be 'false'

  Scenario: {"===":[1,1]}
    Given the rule '{\"===\": [1, 1]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be 'true'

  Scenario: {"===":[1,"1"]}
    Given the rule '{\"===\": [1, \"1\"]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be 'false'

  Scenario: {"===":[1,2]}
    Given the rule '{\"===\": [1, 2]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be 'false'

  Scenario: {"!=":[1,2]}
    Given the rule '{\"!=\": [1, 2]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be 'true'

  Scenario: {"!=":[1,1]}
    Given the rule '{\"!=\": [1, 1]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be 'false'

  Scenario: {"!=":[1,"1"]}
    Given the rule '{\"!=\": [1, \"1\"]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be 'false'

  Scenario: {"!==":[1,2]}
    Given the rule '{\"!==\": [1, 2]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be 'true'

  Scenario: {"!==":[1,1]}
    Given the rule '{\"!==\": [1, 1]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be 'false'

  Scenario: {"!==":[1,"1"]}
    Given the rule '{\"!==\": [1, \"1\"]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be 'true'

  Scenario: {">":[2,1]}
    Given the rule '{\">\": [2, 1]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be 'true'

  Scenario: {">":[1,1]}
    Given the rule '{\">\": [1, 1]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be 'false'

  Scenario: {">":[1,2]}
    Given the rule '{\">\": [1, 2]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be 'false'

  Scenario: {">":["2",1]}
    Given the rule '{\">\": [\"2\", 1]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be 'true'

  Scenario: {">=":[2,1]}
    Given the rule '{\">=\": [2, 1]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be 'true'

  Scenario: {">=":[1,1]}
    Given the rule '{\">=\": [1, 1]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be 'true'

  Scenario: {">=":[1,2]}
    Given the rule '{\">=\": [1, 2]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be 'false'

  Scenario: {">=":["2",1]}
    Given the rule '{\">=\": [\"2\", 1]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be 'true'

  Scenario: {"<":[2,1]}
    Given the rule '{\"<\": [2, 1]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be 'false'

  Scenario: {"<":[1,1]}
    Given the rule '{\"<\": [1, 1]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be 'false'

  Scenario: {"<":[1,2]}
    Given the rule '{\"<\": [1, 2]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be 'true'

  Scenario: {"<":["1",2]}
    Given the rule '{\"<\": [\"1\", 2]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be 'true'

  Scenario: {"<":[1,2,3]}
    Given the rule '{\"<\": [1, 2, 3]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be 'true'

  Scenario: {"<":[1,1,3]}
    Given the rule '{\"<\": [1, 1, 3]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be 'false'

  Scenario: {"<":[1,4,3]}
    Given the rule '{\"<\": [1, 4, 3]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be 'false'

  Scenario: {"<=":[2,1]}
    Given the rule '{\"<=\": [2, 1]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be 'false'

  Scenario: {"<=":[1,1]}
    Given the rule '{\"<=\": [1, 1]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be 'true'

  Scenario: {"<=":[1,2]}
    Given the rule '{\"<=\": [1, 2]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be 'true'

  Scenario: {"<=":["1",2]}
    Given the rule '{\"<=\": [\"1\", 2]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be 'true'

  Scenario: {"<=":[1,2,3]}
    Given the rule '{\"<=\": [1, 2, 3]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be 'true'

  Scenario: {"<=":[1,4,3]}
    Given the rule '{\"<=\": [1, 4, 3]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be 'false'

  Scenario: {"!":[false]}
    Given the rule '{\"!\": [false]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be 'true'

  Scenario: {"!":false}
    Given the rule '{\"!\": false}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be 'true'

  Scenario: {"!":[true]}
    Given the rule '{\"!\": [true]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be 'false'

  Scenario: {"!":true}
    Given the rule '{\"!\": true}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be 'false'

  Scenario: {"!":0}
    Given the rule '{\"!\": 0}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be 'true'

  Scenario: {"!":1}
    Given the rule '{\"!\": 1}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be 'false'

  Scenario: {"or":[true,true]}
    Given the rule '{\"or\": [true, true]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be 'true'

  Scenario: {"or":[false,true]}
    Given the rule '{\"or\": [false, true]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be 'true'

  Scenario: {"or":[true,false]}
    Given the rule '{\"or\": [true, false]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be 'true'

  Scenario: {"or":[false,false]}
    Given the rule '{\"or\": [false, false]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be 'false'

  Scenario: {"or":[false,false,true]}
    Given the rule '{\"or\": [false, false, true]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be 'true'

  Scenario: {"or":[false,false,false]}
    Given the rule '{\"or\": [false, false, false]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be 'false'

  Scenario: {"or":[false]}
    Given the rule '{\"or\": [false]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be 'false'

  Scenario: {"or":[true]}
    Given the rule '{\"or\": [true]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be 'true'

  Scenario: {"or":[1,3]}
    Given the rule '{\"or\": [1, 3]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be '1'

  Scenario: {"or":[3,false]}
    Given the rule '{\"or\": [3, false]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be '3'

  Scenario: {"or":[false,3]}
    Given the rule '{\"or\": [false, 3]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be '3'

  Scenario: {"and":[true,true]}
    Given the rule '{\"and\": [true, true]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be 'true'

  Scenario: {"and":[false,true]}
    Given the rule '{\"and\": [false, true]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be 'false'

  Scenario: {"and":[true,false]}
    Given the rule '{\"and\": [true, false]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be 'false'

  Scenario: {"and":[false,false]}
    Given the rule '{\"and\": [false, false]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be 'false'

  Scenario: {"and":[true,true,true]}
    Given the rule '{\"and\": [true, true, true]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be 'true'

  Scenario: {"and":[true,true,false]}
    Given the rule '{\"and\": [true, true, false]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be 'false'

  Scenario: {"and":[false]}
    Given the rule '{\"and\": [false]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be 'false'

  Scenario: {"and":[true]}
    Given the rule '{\"and\": [true]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be 'true'

  Scenario: {"and":[1,3]}
    Given the rule '{\"and\": [1, 3]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be '3'

  Scenario: {"and":[3,false]}
    Given the rule '{\"and\": [3, false]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be 'false'

  Scenario: {"and":[false,3]}
    Given the rule '{\"and\": [false, 3]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be 'false'

  Scenario: {"?:":[true,1,2]}
    Given the rule '{\"?:\": [true, 1, 2]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be '1'

  Scenario: {"?:":[false,1,2]}
    Given the rule '{\"?:\": [false, 1, 2]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be '2'

  Scenario: {"in":["Bart",["Bart","Homer","Lisa","Marge","Maggie"]]}
    Given the rule '{\"in\": [\"Bart\", [\"Bart\", \"Homer\", \"Lisa\", \"Marge\", \"Maggie\"]]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be 'true'

  Scenario: {"in":["Milhouse",["Bart","Homer","Lisa","Marge","Maggie"]]}
    Given the rule '{\"in\": [\"Milhouse\", [\"Bart\", \"Homer\", \"Lisa\", \"Marge\", \"Maggie\"]]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be 'false'

  Scenario: {"in":["Spring","Springfield"]}
    Given the rule '{\"in\": [\"Spring\", \"Springfield\"]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be 'true'

  Scenario: {"in":["i","team"]}
    Given the rule '{\"in\": [\"i\", \"team\"]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be 'false'

  Scenario: {"cat":"ice"}
    Given the rule '{\"cat\": \"ice\"}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be '\"ice\"'

  Scenario: {"cat":["ice"]}
    Given the rule '{\"cat\": [\"ice\"]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be '\"ice\"'

  Scenario: {"cat":["ice","cream"]}
    Given the rule '{\"cat\": [\"ice\", \"cream\"]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be '\"icecream\"'

  Scenario: {"cat":[1,2]}
    Given the rule '{\"cat\": [1, 2]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be '\"12\"'

  Scenario: {"cat":["Robocop",2]}
    Given the rule '{\"cat\": [\"Robocop\", 2]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be '\"Robocop2\"'

  Scenario: {"cat":["we all scream for ","ice","cream"]}
    Given the rule '{\"cat\": [\"we all scream for \", \"ice\", \"cream\"]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be '\"we all scream for icecream\"'

  Scenario: {"%":[1,2]}
    Given the rule '{\"%\": [1, 2]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be '1'

  Scenario: {"%":[2,2]}
    Given the rule '{\"%\": [2, 2]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be '0'

  Scenario: {"%":[3,2]}
    Given the rule '{\"%\": [3, 2]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be '1'

  Scenario: {"max":[1,2,3]}
    Given the rule '{\"max\": [1, 2, 3]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be '3'

  Scenario: {"max":[1,3,3]}
    Given the rule '{\"max\": [1, 3, 3]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be '3'

  Scenario: {"max":[3,2,1]}
    Given the rule '{\"max\": [3, 2, 1]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be '3'

  Scenario: {"max":[1]}
    Given the rule '{\"max\": [1]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be '1'

  Scenario: {"min":[1,2,3]}
    Given the rule '{\"min\": [1, 2, 3]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be '1'

  Scenario: {"min":[1,1,3]}
    Given the rule '{\"min\": [1, 1, 3]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be '1'

  Scenario: {"min":[3,2,1]}
    Given the rule '{\"min\": [3, 2, 1]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be '1'

  Scenario: {"min":[1]}
    Given the rule '{\"min\": [1]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be '1'

  Scenario: {"+":[1,2]}
    Given the rule '{\"+\": [1, 2]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be '3'

  Scenario: {"+":[2,2,2]}
    Given the rule '{\"+\": [2, 2, 2]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be '6'

  Scenario: {"+":[1]}
    Given the rule '{\"+\": [1]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be '1'

  Scenario: {"+":["1",1]}
    Given the rule '{\"+\": [\"1\", 1]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be '2'

  Scenario: {"*":[3,2]}
    Given the rule '{\"*\": [3, 2]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be '6'

  Scenario: {"*":[2,2,2]}
    Given the rule '{\"*\": [2, 2, 2]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be '8'

  Scenario: {"*":[1]}
    Given the rule '{\"*\": [1]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be '1'

  Scenario: {"*":["1",1]}
    Given the rule '{\"*\": [\"1\", 1]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be '1'

  Scenario: {"-":[2,3]}
    Given the rule '{\"-\": [2, 3]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be '-1'

  Scenario: {"-":[3,2]}
    Given the rule '{\"-\": [3, 2]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be '1'

  Scenario: {"-":[3]}
    Given the rule '{\"-\": [3]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be '-3'

  Scenario: {"-":["1",1]}
    Given the rule '{\"-\": [\"1\", 1]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be '0'

  Scenario: {"/":[4,2]}
    Given the rule '{\"/\": [4, 2]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be '2'

  Scenario: {"/":[2,4]}
    Given the rule '{\"/\": [2, 4]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be '0.5'

  Scenario: {"/":["1",1]}
    Given the rule '{\"/\": [\"1\", 1]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be '1'

  Scenario: {"substr":["jsonlogic",4]}
    Given the rule '{\"substr\": [\"jsonlogic\", 4]}'
    And the data 'null'
    When I evaluate the rule
    Then the result should be '\"logic\"'

  Scenario: {"substr":["jsonlogic",-5]}
    Given the rule '{\"substr\": [\"jsonlogic\", -5]}'
    And the data 'null'
    When I evaluate the rule
    Then the result should be '\"logic\"'

  Scenario: {"substr":["jsonlogic",0,1]}
    Given the rule '{\"substr\": [\"jsonlogic\", 0, 1]}'
    And the data 'null'
    When I evaluate the rule
    Then the result should be '\"j\"'

  Scenario: {"substr":["jsonlogic",-1,1]}
    Given the rule '{\"substr\": [\"jsonlogic\", -1, 1]}'
    And the data 'null'
    When I evaluate the rule
    Then the result should be '\"c\"'

  Scenario: {"substr":["jsonlogic",4,5]}
    Given the rule '{\"substr\": [\"jsonlogic\", 4, 5]}'
    And the data 'null'
    When I evaluate the rule
    Then the result should be '\"logic\"'

  Scenario: {"substr":["jsonlogic",-5,5]}
    Given the rule '{\"substr\": [\"jsonlogic\", -5, 5]}'
    And the data 'null'
    When I evaluate the rule
    Then the result should be '\"logic\"'

  Scenario: {"substr":["jsonlogic",-5,-2]}
    Given the rule '{\"substr\": [\"jsonlogic\", -5, -2]}'
    And the data 'null'
    When I evaluate the rule
    Then the result should be '\"log\"'

  Scenario: {"substr":["jsonlogic",1,-5]}
    Given the rule '{\"substr\": [\"jsonlogic\", 1, -5]}'
    And the data 'null'
    When I evaluate the rule
    Then the result should be '\"son\"'

  Scenario: {"merge":[]}
    Given the rule '{\"merge\": []}'
    And the data 'null'
    When I evaluate the rule
    Then the result should be '[]'

  Scenario: {"merge":[[1]]}
    Given the rule '{\"merge\": [[1]]}'
    And the data 'null'
    When I evaluate the rule
    Then the result should be '[1]'

  Scenario: {"merge":[[1],[]]}
    Given the rule '{\"merge\": [[1], []]}'
    And the data 'null'
    When I evaluate the rule
    Then the result should be '[1]'

  Scenario: {"merge":[[1],[2]]}
    Given the rule '{\"merge\": [[1], [2]]}'
    And the data 'null'
    When I evaluate the rule
    Then the result should be '[1, 2]'

  Scenario: {"merge":[[1],[2],[3]]}
    Given the rule '{\"merge\": [[1], [2], [3]]}'
    And the data 'null'
    When I evaluate the rule
    Then the result should be '[1, 2, 3]'

  Scenario: {"merge":[[1,2],[3]]}
    Given the rule '{\"merge\": [[1, 2], [3]]}'
    And the data 'null'
    When I evaluate the rule
    Then the result should be '[1, 2, 3]'

  Scenario: {"merge":[[1],[2,3]]}
    Given the rule '{\"merge\": [[1], [2, 3]]}'
    And the data 'null'
    When I evaluate the rule
    Then the result should be '[1, 2, 3]'

  Scenario: {"merge":1}
    Given the rule '{\"merge\": 1}'
    And the data 'null'
    When I evaluate the rule
    Then the result should be '[1]'

  Scenario: {"merge":[1,2]}
    Given the rule '{\"merge\": [1, 2]}'
    And the data 'null'
    When I evaluate the rule
    Then the result should be '[1, 2]'

  Scenario: {"merge":[1,[2]]}
    Given the rule '{\"merge\": [1, [2]]}'
    And the data 'null'
    When I evaluate the rule
    Then the result should be '[1, 2]'

  Scenario: {"if":[]}
    Given the rule '{\"if\": []}'
    And the data 'null'
    When I evaluate the rule
    Then the result should be 'null'

  Scenario: {"if":[true]}
    Given the rule '{\"if\": [true]}'
    And the data 'null'
    When I evaluate the rule
    Then the result should be 'true'

  Scenario: {"if":[false]}
    Given the rule '{\"if\": [false]}'
    And the data 'null'
    When I evaluate the rule
    Then the result should be 'false'

  Scenario: {"if":["apple"]}
    Given the rule '{\"if\": [\"apple\"]}'
    And the data 'null'
    When I evaluate the rule
    Then the result should be '\"apple\"'

  Scenario: {"if":[true,"apple"]}
    Given the rule '{\"if\": [true, \"apple\"]}'
    And the data 'null'
    When I evaluate the rule
    Then the result should be '\"apple\"'

  Scenario: {"if":[false,"apple"]}
    Given the rule '{\"if\": [false, \"apple\"]}'
    And the data 'null'
    When I evaluate the rule
    Then the result should be 'null'

  Scenario: {"if":[true,"apple","banana"]}
    Given the rule '{\"if\": [true, \"apple\", \"banana\"]}'
    And the data 'null'
    When I evaluate the rule
    Then the result should be '\"apple\"'

  Scenario: {"if":[false,"apple","banana"]}
    Given the rule '{\"if\": [false, \"apple\", \"banana\"]}'
    And the data 'null'
    When I evaluate the rule
    Then the result should be '\"banana\"'

  Scenario: {"if":[[],"apple","banana"]}
    Given the rule '{\"if\": [[], \"apple\", \"banana\"]}'
    And the data 'null'
    When I evaluate the rule
    Then the result should be '\"banana\"'

  Scenario: {"if":[[1],"apple","banana"]}
    Given the rule '{\"if\": [[1], \"apple\", \"banana\"]}'
    And the data 'null'
    When I evaluate the rule
    Then the result should be '\"apple\"'

  Scenario: {"if":[[1,2,3,4],"apple","banana"]}
    Given the rule '{\"if\": [[1, 2, 3, 4], \"apple\", \"banana\"]}'
    And the data 'null'
    When I evaluate the rule
    Then the result should be '\"apple\"'

  Scenario: {"if":["","apple","banana"]}
    Given the rule '{\"if\": [\"\", \"apple\", \"banana\"]}'
    And the data 'null'
    When I evaluate the rule
    Then the result should be '\"banana\"'

  Scenario: {"if":["zucchini","apple","banana"]}
    Given the rule '{\"if\": [\"zucchini\", \"apple\", \"banana\"]}'
    And the data 'null'
    When I evaluate the rule
    Then the result should be '\"apple\"'

  Scenario: {"if":["0","apple","banana"]}
    Given the rule '{\"if\": [\"0\", \"apple\", \"banana\"]}'
    And the data 'null'
    When I evaluate the rule
    Then the result should be '\"apple\"'

  Scenario: {"===":[0,"0"]}
    Given the rule '{\"===\": [0, \"0\"]}'
    And the data 'null'
    When I evaluate the rule
    Then the result should be 'false'

  Scenario: {"===":[0,{"+":"0"}]}
    Given the rule '{\"===\": [0, {\"+\": \"0\"}]}'
    And the data 'null'
    When I evaluate the rule
    Then the result should be 'true'

  Scenario: {"if":[{"+":"0"},"apple","banana"]}
    Given the rule '{\"if\": [{\"+\": \"0\"}, \"apple\", \"banana\"]}'
    And the data 'null'
    When I evaluate the rule
    Then the result should be '\"banana\"'

  Scenario: {"if":[{"+":"1"},"apple","banana"]}
    Given the rule '{\"if\": [{\"+\": \"1\"}, \"apple\", \"banana\"]}'
    And the data 'null'
    When I evaluate the rule
    Then the result should be '\"apple\"'

  Scenario: {"if":[0,"apple","banana"]}
    Given the rule '{\"if\": [0, \"apple\", \"banana\"]}'
    And the data 'null'
    When I evaluate the rule
    Then the result should be '\"banana\"'

  Scenario: {"if":[1,"apple","banana"]}
    Given the rule '{\"if\": [1, \"apple\", \"banana\"]}'
    And the data 'null'
    When I evaluate the rule
    Then the result should be '\"apple\"'

  Scenario: {"if":[3.1416,"apple","banana"]}
    Given the rule '{\"if\": [3.1416, \"apple\", \"banana\"]}'
    And the data 'null'
    When I evaluate the rule
    Then the result should be '\"apple\"'

  Scenario: {"if":[-1,"apple","banana"]}
    Given the rule '{\"if\": [-1, \"apple\", \"banana\"]}'
    And the data 'null'
    When I evaluate the rule
    Then the result should be '\"apple\"'

  Scenario: {"!":[[]]}
    Given the rule '{\"!\": [[]]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be 'true'

  Scenario: {"!!":[[]]}
    Given the rule '{\"!!\": [[]]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be 'false'

  Scenario: {"and":[[],true]}
    Given the rule '{\"and\": [[], true]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be '[]'

  Scenario: {"or":[[],true]}
    Given the rule '{\"or\": [[], true]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be 'true'

  Scenario: {"!":[0]}
    Given the rule '{\"!\": [0]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be 'true'

  Scenario: {"!!":[0]}
    Given the rule '{\"!!\": [0]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be 'false'

  Scenario: {"and":[0,true]}
    Given the rule '{\"and\": [0, true]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be '0'

  Scenario: {"or":[0,true]}
    Given the rule '{\"or\": [0, true]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be 'true'

  Scenario: {"!":[""]}
    Given the rule '{\"!\": [\"\"]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be 'true'

  Scenario: {"!!":[""]}
    Given the rule '{\"!!\": [\"\"]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be 'false'

  Scenario: {"and":["",true]}
    Given the rule '{\"and\": [\"\", true]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be '\"\"'

  Scenario: {"or":["",true]}
    Given the rule '{\"or\": [\"\", true]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be 'true'

  Scenario: {"!":["0"]}
    Given the rule '{\"!\": [\"0\"]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be 'false'

  Scenario: {"!!":["0"]}
    Given the rule '{\"!!\": [\"0\"]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be 'true'

  Scenario: {"and":["0",true]}
    Given the rule '{\"and\": [\"0\", true]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be 'true'

  Scenario: {"or":["0",true]}
    Given the rule '{\"or\": [\"0\", true]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be '\"0\"'

  Scenario: {"if":[{">":[2,1]},"apple","banana"]}
    Given the rule '{\"if\": [{\">\": [2, 1]}, \"apple\", \"banana\"]}'
    And the data 'null'
    When I evaluate the rule
    Then the result should be '\"apple\"'

  Scenario: {"if":[{">":[1,2]},"apple","banana"]}
    Given the rule '{\"if\": [{\">\": [1, 2]}, \"apple\", \"banana\"]}'
    And the data 'null'
    When I evaluate the rule
    Then the result should be '\"banana\"'

  Scenario: {"if":[true,{"cat":["ap","ple"]},{"cat":["ba","na","na"]}]}
    Given the rule '{\"if\": [true, {\"cat\": [\"ap\", \"ple\"]}, {\"cat\": [\"ba\", \"na\", \"na\"]}]}'
    And the data 'null'
    When I evaluate the rule
    Then the result should be '\"apple\"'

  Scenario: {"if":[false,{"cat":["ap","ple"]},{"cat":["ba","na","na"]}]}
    Given the rule '{\"if\": [false, {\"cat\": [\"ap\", \"ple\"]}, {\"cat\": [\"ba\", \"na\", \"na\"]}]}'
    And the data 'null'
    When I evaluate the rule
    Then the result should be '\"banana\"'

  Scenario: {"if":[true,"apple",true,"banana"]}
    Given the rule '{\"if\": [true, \"apple\", true, \"banana\"]}'
    And the data 'null'
    When I evaluate the rule
    Then the result should be '\"apple\"'

  Scenario: {"if":[true,"apple",false,"banana"]}
    Given the rule '{\"if\": [true, \"apple\", false, \"banana\"]}'
    And the data 'null'
    When I evaluate the rule
    Then the result should be '\"apple\"'

  Scenario: {"if":[false,"apple",true,"banana"]}
    Given the rule '{\"if\": [false, \"apple\", true, \"banana\"]}'
    And the data 'null'
    When I evaluate the rule
    Then the result should be '\"banana\"'

  Scenario: {"if":[false,"apple",false,"banana"]}
    Given the rule '{\"if\": [false, \"apple\", false, \"banana\"]}'
    And the data 'null'
    When I evaluate the rule
    Then the result should be 'null'

  Scenario: {"if":[true,"apple",true,"banana","carrot"]}
    Given the rule '{\"if\": [true, \"apple\", true, \"banana\", \"carrot\"]}'
    And the data 'null'
    When I evaluate the rule
    Then the result should be '\"apple\"'

  Scenario: {"if":[true,"apple",false,"banana","carrot"]}
    Given the rule '{\"if\": [true, \"apple\", false, \"banana\", \"carrot\"]}'
    And the data 'null'
    When I evaluate the rule
    Then the result should be '\"apple\"'

  Scenario: {"if":[false,"apple",true,"banana","carrot"]}
    Given the rule '{\"if\": [false, \"apple\", true, \"banana\", \"carrot\"]}'
    And the data 'null'
    When I evaluate the rule
    Then the result should be '\"banana\"'

  Scenario: {"if":[false,"apple",false,"banana","carrot"]}
    Given the rule '{\"if\": [false, \"apple\", false, \"banana\", \"carrot\"]}'
    And the data 'null'
    When I evaluate the rule
    Then the result should be '\"carrot\"'

  Scenario: {"if":[false,"apple",false,"banana",false,"carrot"]}
    Given the rule '{\"if\": [false, \"apple\", false, \"banana\", false, \"carrot\"]}'
    And the data 'null'
    When I evaluate the rule
    Then the result should be 'null'

  Scenario: {"if":[false,"apple",false,"banana",false,"carrot","date"]}
    Given the rule '{\"if\": [false, \"apple\", false, \"banana\", false, \"carrot\", \"date\"]}'
    And the data 'null'
    When I evaluate the rule
    Then the result should be '\"date\"'

  Scenario: {"if":[false,"apple",false,"banana",true,"carrot","date"]}
    Given the rule '{\"if\": [false, \"apple\", false, \"banana\", true, \"carrot\", \"date\"]}'
    And the data 'null'
    When I evaluate the rule
    Then the result should be '\"carrot\"'

  Scenario: {"if":[false,"apple",true,"banana",false,"carrot","date"]}
    Given the rule '{\"if\": [false, \"apple\", true, \"banana\", false, \"carrot\", \"date\"]}'
    And the data 'null'
    When I evaluate the rule
    Then the result should be '\"banana\"'

  Scenario: {"if":[false,"apple",true,"banana",true,"carrot","date"]}
    Given the rule '{\"if\": [false, \"apple\", true, \"banana\", true, \"carrot\", \"date\"]}'
    And the data 'null'
    When I evaluate the rule
    Then the result should be '\"banana\"'

  Scenario: {"if":[true,"apple",false,"banana",false,"carrot","date"]}
    Given the rule '{\"if\": [true, \"apple\", false, \"banana\", false, \"carrot\", \"date\"]}'
    And the data 'null'
    When I evaluate the rule
    Then the result should be '\"apple\"'

  Scenario: {"if":[true,"apple",false,"banana",true,"carrot","date"]}
    Given the rule '{\"if\": [true, \"apple\", false, \"banana\", true, \"carrot\", \"date\"]}'
    And the data 'null'
    When I evaluate the rule
    Then the result should be '\"apple\"'

  Scenario: {"if":[true,"apple",true,"banana",false,"carrot","date"]}
    Given the rule '{\"if\": [true, \"apple\", true, \"banana\", false, \"carrot\", \"date\"]}'
    And the data 'null'
    When I evaluate the rule
    Then the result should be '\"apple\"'

  Scenario: {"if":[true,"apple",true,"banana",true,"carrot","date"]}
    Given the rule '{\"if\": [true, \"apple\", true, \"banana\", true, \"carrot\", \"date\"]}'
    And the data 'null'
    When I evaluate the rule
    Then the result should be '\"apple\"'

  Scenario: [1,{"var":"x"},3]
    Given the rule '[1, {\"var\": \"x\"}, 3]'
    And the data '{\"x\": 2}'
    When I evaluate the rule
    Then the result should be '[1, 2, 3]'

  Scenario: {"if":[{"var":"x"},[{"var":"y"}],99]}
    Given the rule '{\"if\": [{\"var\": \"x\"}, [{\"var\": \"y\"}], 99]}'
    And the data '{\"x\": true, \"y\": 42}'
    When I evaluate the rule
    Then the result should be '[42]'
