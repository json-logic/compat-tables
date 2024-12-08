module.exports = {
    default: {
        paths: ['../features/*.feature'],
        require: ['jsonlogic.js'],
        format: ['progress-bar', 'json:report.json']
    }
}