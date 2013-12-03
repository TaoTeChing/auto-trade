colors = require "colors" # set output's color
async = require 'async'
fs = require 'fs'
stock = require './lib/stock'
CONFIG = require './config'


data = require CONFIG.recOutput

tasks = []

for item in data.matched
    tasks.push(do (item)->
        return (onFinish)->

            stock.dailyProfit(item, data.date, onFinish)
    )

#console.log data.matched

async.series(tasks, (err, data)->
    console.log(data)
    fs.writeFileSync CONFIG.profit, JSON.stringify(data)
)