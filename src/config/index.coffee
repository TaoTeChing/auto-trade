path = require 'path'
outPrefix = '../../site/data/'

module.exports =
    recOutput: path.resolve(__dirname, "#{outPrefix}recommend.json")
    profit: path.resolve(__dirname, "#{outPrefix}profit.json")