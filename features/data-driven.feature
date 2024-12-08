Feature: JsonLogic Data-Driven

  Testing data-driven operations in JsonLogic

  Scenario: {"var":["a"]}
    Given the rule '{\"var\": [\"a\"]}'
    And the data '{\"a\": 1}'
    When I evaluate the rule
    Then the result should be '1'

  Scenario: {"var":["b"]}
    Given the rule '{\"var\": [\"b\"]}'
    And the data '{\"a\": 1}'
    When I evaluate the rule
    Then the result should be 'null'

  Scenario: {"var":["a"]}
    Given the rule '{\"var\": [\"a\"]}'
    And the data 'null'
    When I evaluate the rule
    Then the result should be 'null'

  Scenario: {"var":"a"}
    Given the rule '{\"var\": \"a\"}'
    And the data '{\"a\": 1}'
    When I evaluate the rule
    Then the result should be '1'

  Scenario: {"var":"b"}
    Given the rule '{\"var\": \"b\"}'
    And the data '{\"a\": 1}'
    When I evaluate the rule
    Then the result should be 'null'

  Scenario: {"var":"a"}
    Given the rule '{\"var\": \"a\"}'
    And the data 'null'
    When I evaluate the rule
    Then the result should be 'null'

  Scenario: {"var":["a",1]}
    Given the rule '{\"var\": [\"a\", 1]}'
    And the data 'null'
    When I evaluate the rule
    Then the result should be '1'

  Scenario: {"var":["b",2]}
    Given the rule '{\"var\": [\"b\", 2]}'
    And the data '{\"a\": 1}'
    When I evaluate the rule
    Then the result should be '2'

  Scenario: {"var":"a.b"}
    Given the rule '{\"var\": \"a.b\"}'
    And the data '{\"a\": {\"b\": \"c\"}}'
    When I evaluate the rule
    Then the result should be '\"c\"'

  Scenario: {"var":"a.q"}
    Given the rule '{\"var\": \"a.q\"}'
    And the data '{\"a\": {\"b\": \"c\"}}'
    When I evaluate the rule
    Then the result should be 'null'

  Scenario: {"var":["a.q",9]}
    Given the rule '{\"var\": [\"a.q\", 9]}'
    And the data '{\"a\": {\"b\": \"c\"}}'
    When I evaluate the rule
    Then the result should be '9'

  Scenario: {"var":1}
    Given the rule '{\"var\": 1}'
    And the data '[\"apple\", \"banana\"]'
    When I evaluate the rule
    Then the result should be '\"banana\"'

  Scenario: {"var":"1"}
    Given the rule '{\"var\": \"1\"}'
    And the data '[\"apple\", \"banana\"]'
    When I evaluate the rule
    Then the result should be '\"banana\"'

  Scenario: {"var":"1.1"}
    Given the rule '{\"var\": \"1.1\"}'
    And the data '[\"apple\", [\"banana\", \"beer\"]]'
    When I evaluate the rule
    Then the result should be '\"beer\"'

  Scenario: {"and":[{"<":[{"var":"temp"},110]},{"==":[{"var":"pie.filling"},"apple"]}]}
    Given the rule '{\"and\": [{\"<\": [{\"var\": \"temp\"}, 110]}, {\"==\": [{\"var\": \"pie.filling\"}, \"apple\"]}]}'
    And the data '{\"temp\": 100, \"pie\": {\"filling\": \"apple\"}}'
    When I evaluate the rule
    Then the result should be 'true'

  Scenario: {"var":[{"?:":[{"<":[{"var":"temp"},110]},"pie.filling","pie.eta"]}]}
    Given the rule '{\"var\": [{\"?:\": [{\"<\": [{\"var\": \"temp\"}, 110]}, \"pie.filling\", \"pie.eta\"]}]}'
    And the data '{\"temp\": 100, \"pie\": {\"filling\": \"apple\", \"eta\": \"60s\"}}'
    When I evaluate the rule
    Then the result should be '\"apple\"'

  Scenario: {"in":[{"var":"filling"},["apple","cherry"]]}
    Given the rule '{\"in\": [{\"var\": \"filling\"}, [\"apple\", \"cherry\"]]}'
    And the data '{\"filling\": \"apple\"}'
    When I evaluate the rule
    Then the result should be 'true'

  Scenario: {"var":"a.b.c"}
    Given the rule '{\"var\": \"a.b.c\"}'
    And the data 'null'
    When I evaluate the rule
    Then the result should be 'null'

  Scenario: {"var":"a.b.c"}
    Given the rule '{\"var\": \"a.b.c\"}'
    And the data '{\"a\": null}'
    When I evaluate the rule
    Then the result should be 'null'

  Scenario: {"var":"a.b.c"}
    Given the rule '{\"var\": \"a.b.c\"}'
    And the data '{\"a\": {\"b\": null}}'
    When I evaluate the rule
    Then the result should be 'null'

  Scenario: {"var":""}
    Given the rule '{\"var\": \"\"}'
    And the data '1'
    When I evaluate the rule
    Then the result should be '1'

  Scenario: {"var":null}
    Given the rule '{\"var\": null}'
    And the data '1'
    When I evaluate the rule
    Then the result should be '1'

  Scenario: {"var":[]}
    Given the rule '{\"var\": []}'
    And the data '1'
    When I evaluate the rule
    Then the result should be '1'

  Scenario: {"missing":[]}
    Given the rule '{\"missing\": []}'
    And the data 'null'
    When I evaluate the rule
    Then the result should be '[]'

  Scenario: {"missing":["a"]}
    Given the rule '{\"missing\": [\"a\"]}'
    And the data 'null'
    When I evaluate the rule
    Then the result should be '[\"a\"]'

  Scenario: {"missing":"a"}
    Given the rule '{\"missing\": \"a\"}'
    And the data 'null'
    When I evaluate the rule
    Then the result should be '[\"a\"]'

  Scenario: {"missing":"a"}
    Given the rule '{\"missing\": \"a\"}'
    And the data '{\"a\": \"apple\"}'
    When I evaluate the rule
    Then the result should be '[]'

  Scenario: {"missing":["a"]}
    Given the rule '{\"missing\": [\"a\"]}'
    And the data '{\"a\": \"apple\"}'
    When I evaluate the rule
    Then the result should be '[]'

  Scenario: {"missing":["a","b"]}
    Given the rule '{\"missing\": [\"a\", \"b\"]}'
    And the data '{\"a\": \"apple\"}'
    When I evaluate the rule
    Then the result should be '[\"b\"]'

  Scenario: {"missing":["a","b"]}
    Given the rule '{\"missing\": [\"a\", \"b\"]}'
    And the data '{\"b\": \"banana\"}'
    When I evaluate the rule
    Then the result should be '[\"a\"]'

  Scenario: {"missing":["a","b"]}
    Given the rule '{\"missing\": [\"a\", \"b\"]}'
    And the data '{\"a\": \"apple\", \"b\": \"banana\"}'
    When I evaluate the rule
    Then the result should be '[]'

  Scenario: {"missing":["a","b"]}
    Given the rule '{\"missing\": [\"a\", \"b\"]}'
    And the data '{}'
    When I evaluate the rule
    Then the result should be '[\"a\", \"b\"]'

  Scenario: {"missing":["a","b"]}
    Given the rule '{\"missing\": [\"a\", \"b\"]}'
    And the data 'null'
    When I evaluate the rule
    Then the result should be '[\"a\", \"b\"]'

  Scenario: {"missing":["a.b"]}
    Given the rule '{\"missing\": [\"a.b\"]}'
    And the data 'null'
    When I evaluate the rule
    Then the result should be '[\"a.b\"]'

  Scenario: {"missing":["a.b"]}
    Given the rule '{\"missing\": [\"a.b\"]}'
    And the data '{\"a\": \"apple\"}'
    When I evaluate the rule
    Then the result should be '[\"a.b\"]'

  Scenario: {"missing":["a.b"]}
    Given the rule '{\"missing\": [\"a.b\"]}'
    And the data '{\"a\": {\"c\": \"apple cake\"}}'
    When I evaluate the rule
    Then the result should be '[\"a.b\"]'

  Scenario: {"missing":["a.b"]}
    Given the rule '{\"missing\": [\"a.b\"]}'
    And the data '{\"a\": {\"b\": \"apple brownie\"}}'
    When I evaluate the rule
    Then the result should be '[]'

  Scenario: {"missing":["a.b","a.c"]}
    Given the rule '{\"missing\": [\"a.b\", \"a.c\"]}'
    And the data '{\"a\": {\"b\": \"apple brownie\"}}'
    When I evaluate the rule
    Then the result should be '[\"a.c\"]'

  Scenario: {"missing_some":[1,["a","b"]]}
    Given the rule '{\"missing_some\": [1, [\"a\", \"b\"]]}'
    And the data '{\"a\": \"apple\"}'
    When I evaluate the rule
    Then the result should be '[]'

  Scenario: {"missing_some":[1,["a","b"]]}
    Given the rule '{\"missing_some\": [1, [\"a\", \"b\"]]}'
    And the data '{\"b\": \"banana\"}'
    When I evaluate the rule
    Then the result should be '[]'

  Scenario: {"missing_some":[1,["a","b"]]}
    Given the rule '{\"missing_some\": [1, [\"a\", \"b\"]]}'
    And the data '{\"a\": \"apple\", \"b\": \"banana\"}'
    When I evaluate the rule
    Then the result should be '[]'

  Scenario: {"missing_some":[1,["a","b"]]}
    Given the rule '{\"missing_some\": [1, [\"a\", \"b\"]]}'
    And the data '{\"c\": \"carrot\"}'
    When I evaluate the rule
    Then the result should be '[\"a\", \"b\"]'

  Scenario: {"missing_some":[2,["a","b","c"]]}
    Given the rule '{\"missing_some\": [2, [\"a\", \"b\", \"c\"]]}'
    And the data '{\"a\": \"apple\", \"b\": \"banana\"}'
    When I evaluate the rule
    Then the result should be '[]'

  Scenario: {"missing_some":[2,["a","b","c"]]}
    Given the rule '{\"missing_some\": [2, [\"a\", \"b\", \"c\"]]}'
    And the data '{\"a\": \"apple\", \"c\": \"carrot\"}'
    When I evaluate the rule
    Then the result should be '[]'

  Scenario: {"missing_some":[2,["a","b","c"]]}
    Given the rule '{\"missing_some\": [2, [\"a\", \"b\", \"c\"]]}'
    And the data '{\"a\": \"apple\", \"b\": \"banana\", \"c\": \"carrot\"}'
    When I evaluate the rule
    Then the result should be '[]'

  Scenario: {"missing_some":[2,["a","b","c"]]}
    Given the rule '{\"missing_some\": [2, [\"a\", \"b\", \"c\"]]}'
    And the data '{\"a\": \"apple\", \"d\": \"durian\"}'
    When I evaluate the rule
    Then the result should be '[\"b\", \"c\"]'

  Scenario: {"missing_some":[2,["a","b","c"]]}
    Given the rule '{\"missing_some\": [2, [\"a\", \"b\", \"c\"]]}'
    And the data '{\"d\": \"durian\", \"e\": \"eggplant\"}'
    When I evaluate the rule
    Then the result should be '[\"a\", \"b\", \"c\"]'

  Scenario: {"if":[{"missing":"a"},"missed it","found it"]}
    Given the rule '{\"if\": [{\"missing\": \"a\"}, \"missed it\", \"found it\"]}'
    And the data '{\"a\": \"apple\"}'
    When I evaluate the rule
    Then the result should be '\"found it\"'

  Scenario: {"if":[{"missing":"a"},"missed it","found it"]}
    Given the rule '{\"if\": [{\"missing\": \"a\"}, \"missed it\", \"found it\"]}'
    And the data '{\"b\": \"banana\"}'
    When I evaluate the rule
    Then the result should be '\"missed it\"'

  Scenario: {"missing":{"merge":["vin",{"if":[{"var":"financing"},["apr"],[]]}]}}
    Given the rule '{\"missing\": {\"merge\": [\"vin\", {\"if\": [{\"var\": \"financing\"}, [\"apr\"], []]}]}}'
    And the data '{\"financing\": true}'
    When I evaluate the rule
    Then the result should be '[\"vin\", \"apr\"]'

  Scenario: {"missing":{"merge":["vin",{"if":[{"var":"financing"},["apr"],[]]}]}}
    Given the rule '{\"missing\": {\"merge\": [\"vin\", {\"if\": [{\"var\": \"financing\"}, [\"apr\"], []]}]}}'
    And the data '{\"financing\": false}'
    When I evaluate the rule
    Then the result should be '[\"vin\"]'

  Scenario: {"filter":[{"var":"integers"},true]}
    Given the rule '{\"filter\": [{\"var\": \"integers\"}, true]}'
    And the data '{\"integers\": [1, 2, 3]}'
    When I evaluate the rule
    Then the result should be '[1, 2, 3]'

  Scenario: {"filter":[{"var":"integers"},false]}
    Given the rule '{\"filter\": [{\"var\": \"integers\"}, false]}'
    And the data '{\"integers\": [1, 2, 3]}'
    When I evaluate the rule
    Then the result should be '[]'

  Scenario: {"filter":[{"var":"integers"},{">=":[{"var":""},2]}]}
    Given the rule '{\"filter\": [{\"var\": \"integers\"}, {\">=\": [{\"var\": \"\"}, 2]}]}'
    And the data '{\"integers\": [1, 2, 3]}'
    When I evaluate the rule
    Then the result should be '[2, 3]'

  Scenario: {"filter":[{"var":"integers"},{"%":[{"var":""},2]}]}
    Given the rule '{\"filter\": [{\"var\": \"integers\"}, {\"%\": [{\"var\": \"\"}, 2]}]}'
    And the data '{\"integers\": [1, 2, 3]}'
    When I evaluate the rule
    Then the result should be '[1, 3]'

  Scenario: {"map":[{"var":"integers"},{"*":[{"var":""},2]}]}
    Given the rule '{\"map\": [{\"var\": \"integers\"}, {\"*\": [{\"var\": \"\"}, 2]}]}'
    And the data '{\"integers\": [1, 2, 3]}'
    When I evaluate the rule
    Then the result should be '[2, 4, 6]'

  Scenario: {"map":[{"var":"integers"},{"*":[{"var":""},2]}]}
    Given the rule '{\"map\": [{\"var\": \"integers\"}, {\"*\": [{\"var\": \"\"}, 2]}]}'
    And the data 'null'
    When I evaluate the rule
    Then the result should be '[]'

  Scenario: {"map":[{"var":"desserts"},{"var":"qty"}]}
    Given the rule '{\"map\": [{\"var\": \"desserts\"}, {\"var\": \"qty\"}]}'
    And the data '{\"desserts\": [{\"name\": \"apple\", \"qty\": 1}, {\"name\": \"brownie\", \"qty\": 2}, {\"name\": \"cupcake\", \"qty\": 3}]}'
    When I evaluate the rule
    Then the result should be '[1, 2, 3]'

  Scenario: {"reduce":[{"var":"integers"},{"+":[{"var":"current"},{"var":"accumulator"}]},0]}
    Given the rule '{\"reduce\": [{\"var\": \"integers\"}, {\"+\": [{\"var\": \"current\"}, {\"var\": \"accumulator\"}]}, 0]}'
    And the data '{\"integers\": [1, 2, 3, 4]}'
    When I evaluate the rule
    Then the result should be '10'

  Scenario: {"reduce":[{"var":"integers"},{"+":[{"var":"current"},{"var":"accumulator"}]},{"var":"start_with"}]}
    Given the rule '{\"reduce\": [{\"var\": \"integers\"}, {\"+\": [{\"var\": \"current\"}, {\"var\": \"accumulator\"}]}, {\"var\": \"start_with\"}]}'
    And the data '{\"integers\": [1, 2, 3, 4], \"start_with\": 59}'
    When I evaluate the rule
    Then the result should be '69'

  Scenario: {"reduce":[{"var":"integers"},{"+":[{"var":"current"},{"var":"accumulator"}]},0]}
    Given the rule '{\"reduce\": [{\"var\": \"integers\"}, {\"+\": [{\"var\": \"current\"}, {\"var\": \"accumulator\"}]}, 0]}'
    And the data 'null'
    When I evaluate the rule
    Then the result should be '0'

  Scenario: {"reduce":[{"var":"integers"},{"*":[{"var":"current"},{"var":"accumulator"}]},1]}
    Given the rule '{\"reduce\": [{\"var\": \"integers\"}, {\"*\": [{\"var\": \"current\"}, {\"var\": \"accumulator\"}]}, 1]}'
    And the data '{\"integers\": [1, 2, 3, 4]}'
    When I evaluate the rule
    Then the result should be '24'

  Scenario: {"reduce":[{"var":"integers"},{"*":[{"var":"current"},{"var":"accumulator"}]},0]}
    Given the rule '{\"reduce\": [{\"var\": \"integers\"}, {\"*\": [{\"var\": \"current\"}, {\"var\": \"accumulator\"}]}, 0]}'
    And the data '{\"integers\": [1, 2, 3, 4]}'
    When I evaluate the rule
    Then the result should be '0'

  Scenario: {"reduce":[{"var":"desserts"},{"+":[{"var":"accumulator"},{"var":"current.qty"}]},0]}
    Given the rule '{\"reduce\": [{\"var\": \"desserts\"}, {\"+\": [{\"var\": \"accumulator\"}, {\"var\": \"current.qty\"}]}, 0]}'
    And the data '{\"desserts\": [{\"name\": \"apple\", \"qty\": 1}, {\"name\": \"brownie\", \"qty\": 2}, {\"name\": \"cupcake\", \"qty\": 3}]}'
    When I evaluate the rule
    Then the result should be '6'

  Scenario: {"all":[{"var":"integers"},{">=":[{"var":""},1]}]}
    Given the rule '{\"all\": [{\"var\": \"integers\"}, {\">=\": [{\"var\": \"\"}, 1]}]}'
    And the data '{\"integers\": [1, 2, 3]}'
    When I evaluate the rule
    Then the result should be 'true'

  Scenario: {"all":[{"var":"integers"},{"==":[{"var":""},1]}]}
    Given the rule '{\"all\": [{\"var\": \"integers\"}, {\"==\": [{\"var\": \"\"}, 1]}]}'
    And the data '{\"integers\": [1, 2, 3]}'
    When I evaluate the rule
    Then the result should be 'false'

  Scenario: {"all":[{"var":"integers"},{"<":[{"var":""},1]}]}
    Given the rule '{\"all\": [{\"var\": \"integers\"}, {\"<\": [{\"var\": \"\"}, 1]}]}'
    And the data '{\"integers\": [1, 2, 3]}'
    When I evaluate the rule
    Then the result should be 'false'

  Scenario: {"all":[{"var":"integers"},{"<":[{"var":""},1]}]}
    Given the rule '{\"all\": [{\"var\": \"integers\"}, {\"<\": [{\"var\": \"\"}, 1]}]}'
    And the data '{\"integers\": []}'
    When I evaluate the rule
    Then the result should be 'false'

  Scenario: {"all":[{"var":"items"},{">=":[{"var":"qty"},1]}]}
    Given the rule '{\"all\": [{\"var\": \"items\"}, {\">=\": [{\"var\": \"qty\"}, 1]}]}'
    And the data '{\"items\": [{\"qty\": 1, \"sku\": \"apple\"}, {\"qty\": 2, \"sku\": \"banana\"}]}'
    When I evaluate the rule
    Then the result should be 'true'

  Scenario: {"all":[{"var":"items"},{">":[{"var":"qty"},1]}]}
    Given the rule '{\"all\": [{\"var\": \"items\"}, {\">\": [{\"var\": \"qty\"}, 1]}]}'
    And the data '{\"items\": [{\"qty\": 1, \"sku\": \"apple\"}, {\"qty\": 2, \"sku\": \"banana\"}]}'
    When I evaluate the rule
    Then the result should be 'false'

  Scenario: {"all":[{"var":"items"},{"<":[{"var":"qty"},1]}]}
    Given the rule '{\"all\": [{\"var\": \"items\"}, {\"<\": [{\"var\": \"qty\"}, 1]}]}'
    And the data '{\"items\": [{\"qty\": 1, \"sku\": \"apple\"}, {\"qty\": 2, \"sku\": \"banana\"}]}'
    When I evaluate the rule
    Then the result should be 'false'

  Scenario: {"all":[{"var":"items"},{">=":[{"var":"qty"},1]}]}
    Given the rule '{\"all\": [{\"var\": \"items\"}, {\">=\": [{\"var\": \"qty\"}, 1]}]}'
    And the data '{\"items\": []}'
    When I evaluate the rule
    Then the result should be 'false'

  Scenario: {"none":[{"var":"integers"},{">=":[{"var":""},1]}]}
    Given the rule '{\"none\": [{\"var\": \"integers\"}, {\">=\": [{\"var\": \"\"}, 1]}]}'
    And the data '{\"integers\": [1, 2, 3]}'
    When I evaluate the rule
    Then the result should be 'false'

  Scenario: {"none":[{"var":"integers"},{"==":[{"var":""},1]}]}
    Given the rule '{\"none\": [{\"var\": \"integers\"}, {\"==\": [{\"var\": \"\"}, 1]}]}'
    And the data '{\"integers\": [1, 2, 3]}'
    When I evaluate the rule
    Then the result should be 'false'

  Scenario: {"none":[{"var":"integers"},{"<":[{"var":""},1]}]}
    Given the rule '{\"none\": [{\"var\": \"integers\"}, {\"<\": [{\"var\": \"\"}, 1]}]}'
    And the data '{\"integers\": [1, 2, 3]}'
    When I evaluate the rule
    Then the result should be 'true'

  Scenario: {"none":[{"var":"integers"},{"<":[{"var":""},1]}]}
    Given the rule '{\"none\": [{\"var\": \"integers\"}, {\"<\": [{\"var\": \"\"}, 1]}]}'
    And the data '{\"integers\": []}'
    When I evaluate the rule
    Then the result should be 'true'

  Scenario: {"none":[{"var":"items"},{">=":[{"var":"qty"},1]}]}
    Given the rule '{\"none\": [{\"var\": \"items\"}, {\">=\": [{\"var\": \"qty\"}, 1]}]}'
    And the data '{\"items\": [{\"qty\": 1, \"sku\": \"apple\"}, {\"qty\": 2, \"sku\": \"banana\"}]}'
    When I evaluate the rule
    Then the result should be 'false'

  Scenario: {"none":[{"var":"items"},{">":[{"var":"qty"},1]}]}
    Given the rule '{\"none\": [{\"var\": \"items\"}, {\">\": [{\"var\": \"qty\"}, 1]}]}'
    And the data '{\"items\": [{\"qty\": 1, \"sku\": \"apple\"}, {\"qty\": 2, \"sku\": \"banana\"}]}'
    When I evaluate the rule
    Then the result should be 'false'

  Scenario: {"none":[{"var":"items"},{"<":[{"var":"qty"},1]}]}
    Given the rule '{\"none\": [{\"var\": \"items\"}, {\"<\": [{\"var\": \"qty\"}, 1]}]}'
    And the data '{\"items\": [{\"qty\": 1, \"sku\": \"apple\"}, {\"qty\": 2, \"sku\": \"banana\"}]}'
    When I evaluate the rule
    Then the result should be 'true'

  Scenario: {"none":[{"var":"items"},{">=":[{"var":"qty"},1]}]}
    Given the rule '{\"none\": [{\"var\": \"items\"}, {\">=\": [{\"var\": \"qty\"}, 1]}]}'
    And the data '{\"items\": []}'
    When I evaluate the rule
    Then the result should be 'true'

  Scenario: {"some":[{"var":"integers"},{">=":[{"var":""},1]}]}
    Given the rule '{\"some\": [{\"var\": \"integers\"}, {\">=\": [{\"var\": \"\"}, 1]}]}'
    And the data '{\"integers\": [1, 2, 3]}'
    When I evaluate the rule
    Then the result should be 'true'

  Scenario: {"some":[{"var":"integers"},{"==":[{"var":""},1]}]}
    Given the rule '{\"some\": [{\"var\": \"integers\"}, {\"==\": [{\"var\": \"\"}, 1]}]}'
    And the data '{\"integers\": [1, 2, 3]}'
    When I evaluate the rule
    Then the result should be 'true'

  Scenario: {"some":[{"var":"integers"},{"<":[{"var":""},1]}]}
    Given the rule '{\"some\": [{\"var\": \"integers\"}, {\"<\": [{\"var\": \"\"}, 1]}]}'
    And the data '{\"integers\": [1, 2, 3]}'
    When I evaluate the rule
    Then the result should be 'false'

  Scenario: {"some":[{"var":"integers"},{"<":[{"var":""},1]}]}
    Given the rule '{\"some\": [{\"var\": \"integers\"}, {\"<\": [{\"var\": \"\"}, 1]}]}'
    And the data '{\"integers\": []}'
    When I evaluate the rule
    Then the result should be 'false'

  Scenario: {"some":[{"var":"items"},{">=":[{"var":"qty"},1]}]}
    Given the rule '{\"some\": [{\"var\": \"items\"}, {\">=\": [{\"var\": \"qty\"}, 1]}]}'
    And the data '{\"items\": [{\"qty\": 1, \"sku\": \"apple\"}, {\"qty\": 2, \"sku\": \"banana\"}]}'
    When I evaluate the rule
    Then the result should be 'true'

  Scenario: {"some":[{"var":"items"},{">":[{"var":"qty"},1]}]}
    Given the rule '{\"some\": [{\"var\": \"items\"}, {\">\": [{\"var\": \"qty\"}, 1]}]}'
    And the data '{\"items\": [{\"qty\": 1, \"sku\": \"apple\"}, {\"qty\": 2, \"sku\": \"banana\"}]}'
    When I evaluate the rule
    Then the result should be 'true'

  Scenario: {"some":[{"var":"items"},{"<":[{"var":"qty"},1]}]}
    Given the rule '{\"some\": [{\"var\": \"items\"}, {\"<\": [{\"var\": \"qty\"}, 1]}]}'
    And the data '{\"items\": [{\"qty\": 1, \"sku\": \"apple\"}, {\"qty\": 2, \"sku\": \"banana\"}]}'
    When I evaluate the rule
    Then the result should be 'false'

  Scenario: {"some":[{"var":"items"},{">=":[{"var":"qty"},1]}]}
    Given the rule '{\"some\": [{\"var\": \"items\"}, {\">=\": [{\"var\": \"qty\"}, 1]}]}'
    And the data '{\"items\": []}'
    When I evaluate the rule
    Then the result should be 'false'
