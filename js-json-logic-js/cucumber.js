module.exports = {
    default: {
        paths: ['../features/*.feature'],
        require: ['jsonlogic.js'],
        format: ['progress-bar', 'json:../reports/json-logic-js.json']
    }
}