colors = require "colors" # set output's color
#db = require './db'
stock = require '../lib/stock'

id = process.argv[2] || '002170'
date = process.argv[3] || '2013-11-18'
sep = process.argv[4] || 250

console.log "#{id}, #{date}, #{sep}"

stock.averagePrice(id, date, sep)