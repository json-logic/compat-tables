module.exports = {
    default: {
        paths: ['../features/*.feature'],
        require: ['json-logic-js.js'],
        format: ['progress-bar', 'json:../reports/json-logic-js.json']
    }
}