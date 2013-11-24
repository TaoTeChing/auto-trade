colors = require "colors" # set output's color
stock = require './lib/stock'
async = require 'async'


id = '300344'
date = '2013-11-15'

isHit = (data, id, onFinish)->
    openP = data.daily.open
    closeP = data.daily.close
    averageP = data.average.avg

    console.log data

    if openP < averageP and averageP < closeP
        console.log "[O] #{id}"
    else
        console.log "[X] #{id}"
    onFinish()

checkPrice = (id, date, onFinish)->
    async.parallel(
        daily: (cb)->
            stock.dailyPrice(id, date, cb)
        average: (cb)->
            stock.averagePrice(id, date, 250, cb)
    , (err, data)->
        isHit(data, id, onFinish)
    )

#stock.dailyPrice(id, date)
#stock.averagePrice(id, date, 250)

#checkPrice(id, date)
tasks = []
for num in [0...10]
    tasks.push((onFinish)->
        checkPrice(id, date, onFinish)
    )

#tasks[2] = CheckPrice('002687', date)
console.log tasks
async.series(tasks)