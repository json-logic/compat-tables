// cucumber.js
module.exports = {
    default: {
        paths: ['../features/*.feature'],
        require: ['jsonlogic.js'],
        format: ['progress-bar', 'html:cucumber-report.html']
    }
}