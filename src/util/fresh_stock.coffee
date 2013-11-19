colors = require "colors" # set output's color
#db = require './db'
stock = require '../lib/stock'
stock.url = require '../api/url-getter'



stock.getSinaData(stock.url['fresh'](), (data)->
    stock.saveSinaData(data, 'fresh_stock')
)