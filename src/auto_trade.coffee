colors = require "colors" # set output's color
stock = require './lib/stock'
async = require 'async'
fs = require 'fs'

id = '300344'
date = '2013-11-15'

isHit = (data, id, onFinish)->
    openP = data.daily.open
    closeP = data.daily.close
    averageP = data.average.avg

    #console.log data
    count++
    if openP < averageP and averageP < closeP
        console.log "[O] #{id}"
        matched.push(id)
    else
        console.log "XXX #{id}"
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

stocks = require('../data/stock_list.json')
try
    data = require('./auto_trade_data/matched.json')
catch err
    data = {}
matched = data.matched || []
count = ii = data.count || 0
i = 0
l = 100
tasks = []
for key, value of  stocks
    continue if ii-- > 0
    break if i++ >= l
    tasks.push(do (key)->
        return (onFinish)->
            checkPrice(key, date, onFinish)
    )

#tasks[2] = CheckPrice('002687', date)
# console.log tasks
# console.log tasks

async.series(tasks)

beforeExit = ()->
    data.matched = matched if not data.matched
    data.count = count
    console.log data
    fs.writeFileSync './auto_trade_data/matched.json', JSON.stringify(data)
    do process.exit

process.on 'SIGINT', beforeExit
process.on 'exit', beforeExit