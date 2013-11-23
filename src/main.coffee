fs = require "fs"
colors = require "colors" # set output's color
stock = require './lib/stock'


###
	判断是否为涨停
###
round = (num, fractionDigits)->
    
    
stock.isTradingLimit = (stock)->
    if stock.settlement # 昨日收盘价
        currentPrice = Math.round((stock.trade - 0)*100) # 买一价钱
        # 涨停的理论涨幅
        tradingLimit = Math.round( stock.settlement * 110 )
        return tradingLimit is currentPrice
    else
        return false


###
	stock.fetchTopLimit 获取沪深股市的涨幅榜，
        - num：每次取的数目，num可以设置成大于股票总数的值，一次取回所有股票的涨幅
		- page: 取第几页的数据
###
stock.fetchTopLimit = ()->
    ret = []
    i = 1
    step = 40
    urlGetter = stock.url['topList']
    this.getSinaData(urlGetter(step, i), (data)->
        if (count = tradingLimitCount(data)) is 40
            # 该页全是涨停
            ret = ret.concat(data)
            stock.getSinaData(urlGetter(step, ++i), arguments.callee)
        else
            #
            ret = ret.concat(data[0...count])
            stock.saveSinaData(ret)
    )
###

###
tradingLimitCount = (data)->
    count = 0
    for item in data
        if stock.isTradingLimit(item)
            count++
        else
            console.log "第一个非涨停的股票：#{item.name}"
            return count
    return count


###
    stock.getAllStockCode
        根据所有股票的涨幅来获取沪深股市的所有股票代码
###

stock.getAllStockCode = (area)->
    target =
        sh: 'ss'
        sz: 'sz'

    if !area
        callback = (data)->
            ret = []
            console.log "共有#{data.length}条股票记录"

            data.forEach((item, i)->
                symbol = item.symbol
                flag = symbol[0...2]
                if flag is 'sh'
                    code = symbol[2...] + '.ss'
                    ret.push(code)
                else if flag is 'sz'
                    code = symbol[2...] + '.sz'
                    ret.push(code)
            )

            fs.writeFileSync('../data/stock_code_list_all', ret.join(","))
            console.log "#{ret.length} records saved to \"../data/stock_code_list_all\" !"
    else
        callback = (data)->
            ret = []
            console.log "共有#{data.length}条股票记录"

            data.forEach((item, i)->
                if item.symbol[0...2] is area
                    code = item.symbol[2...] + '.' + target[area]
                    ret.push(code)
            )

            fs.writeFileSync("../data/stock_code_list_#{area}", ret.join(","))
            console.log "#{ret.length} records saved to \"../data/stock_code_list_#{area}\" !"


    stock.getSinaData(stock.url['topList'](3000,1), callback)

###
    Main program
###
stock.fetchTopLimit()
