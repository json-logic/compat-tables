module.exports = {
    default: {
        paths: ['../features/*.feature'],
        require: ['json-logic-engine.js'],
        format: ['progress-bar', 'json:../reports/json-logic-engine.json']
    }
}
