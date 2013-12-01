colors = require "colors" # set output's color
stock = require './lib/stock'
async = require 'async'
fs = require 'fs'

id = '300344'
date = '2013-06-25'

isHit = (data, id, onFinish)->
    openP = Number(data.daily.open)
    closeP = Number(data.daily.close)
    averageP = Number(data.average.avg)

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
output = '../site/data/recommend'
try
    data = require(output)
catch err
    data = {}
matched = data.matched || []
count = ii = data.count || 0
i = 0
l = 3000
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
    return if arguments.callee.init
    arguments.callee.init = true
    data.matched = matched if not data.matched
    data.count = count
    data.id = id
    data.date = date
    console.log data
    fs.writeFileSync output, JSON.stringify(data)
    do process.exit

process.on 'exit', beforeExit
process.on 'SIGINT', beforeExit