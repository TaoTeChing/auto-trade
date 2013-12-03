colors = require "colors" # set output's color
stock = require './lib/stock'
async = require 'async'
fs = require 'fs'
CONFIG = require './config'

date = process.argv[2] # '2013-06-25'
console.log "请输入日期".error if not date

isHit = (data, id, onFinish)->
    openP = Number(data.daily.open)
    closeP = Number(data.daily.close)
    averageP = Number(data.average.avg)

    #console.log data
    count++
    if openP < averageP and averageP < closeP* 0.99
        console.log "[O] #{id}"
        matched.push(id)
    else
#        console.log "XXX #{id}"
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

if process.argv[4] == 'continue'
    try
        data = require(CONFIG.recOutput)
    catch err
        data = {}
else
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
    data.date = date
    console.log data
    fs.writeFileSync CONFIG.recOutput, JSON.stringify(data)
    do process.exit

process.on 'exit', beforeExit
process.on 'SIGINT', beforeExit