http = require "http"
iconv = require 'iconv-lite' # convert encoding
BufferHelper = require 'bufferhelper'
db = require "#{__dirname}/db"

stock = {}
###
    加载数据底层API
###
stock.getSinaData = (url, callback)->
    options =
        hostname: stock.url.host
        port: 80
        path: url
        method: "GET"

    req = http.request options, (res)->
        bufferHelper = new BufferHelper();
        #console.log "[connected] #{url.cyan.underline}"

        res.on 'data', (chunk)->
            bufferHelper.concat(chunk)

        res.on 'end', ()->
            retString = iconv.decode bufferHelper.toBuffer(), 'GB2312'
            data = eval "#{retString}"
            callback data

    # handle error
    req.on('error', (e)->
        console.error "problem with request: {#e.message}"
    )
    # send request
    req.end()

###
    保存从新浪获取的数据
###
stock.saveSinaData = (data, tableName)->
    db.save(data, tableName)



###
   获取股票某天的开盘价和收盘价
###
stock.dailyPrice = (id, start, cb)->
    data =
        id: id
        cmd: 'open_close'
        date: start

    stock._getTradeInfo(data, cb)
###
   获取买入股票第二天卖出的收益率
###
stock.dailyProfit = (id, date, cb)->
    data =
        id: id
        cmd: 'rise'
        date: date
        len: 2

    stock._getTradeInfo(data, cb)
###
    获取股价的平均价格
###
stock.averagePrice = (id, start = util.getTime(), sep, cb)->
    data =
        id: id
        cmd: 'avg'
        date: start
        len: sep

    # 新方法
    return stock._getTradeInfo(data, cb)

    # 旧API
    data =
        id: id
        date: start
        len: sep
    dataStr = JSON.stringify(data)
    # console.log "#{id}(#{start})的#{sep}日均价#{dataStr}"

    options =
        hostname: 'uclink.org'
        path: '/getAvg.php'
        method: 'POST'
        headers:
            'Content-Type': 'application/x-www-form-urlencoded',
            'Content-Length': dataStr.length


    req = http.request options, (res)->
        # console.log res
        res.setEncoding('utf-8')
        res.on('data', (chunk)->
            if cb
                try
                    data = JSON.parse(chunk)
                catch err

                cb(null, data)
            else
                console.log chunk
        )

    req.on('error', (err)->
        console.log err
    )

    req.write(dataStr)
    req.end()
###
    向uclink.org发起查询请求
###
stock._getTradeInfo = (data, cb)->
    dataStr = JSON.stringify(data)
    options =
        hostname: 'uclink.org'
        path: '/getStock.php'
        method: 'POST'
        headers:
            'Content-Type': 'application/x-www-form-urlencoded'
            'Content-Length': dataStr.length

    req = http.request options, (res)->
        res.setEncoding 'utf-8'
        res.on 'data', (chunk)->
            if cb
                try
                    data = JSON.parse(chunk)
                catch err
                cb(null, data)
            else
                console.log chunk

        req.on 'error', (err)->
            cb?(err)

    req.write(dataStr)
    req.end()
###
    配置新浪URL接口
###
stock.url =
    host: 'vip.stock.finance.sina.com.cn'
    topList: (num=40, index=1)->
        return "/quotes_service/api/json_v2.php/Market_Center.getHQNodeData?page=#{index}&num=#{num}&sort=changepercent&asc=0&node=hs_a&_s_r_a=init"
    fresh: ()->
        return "/quotes_service/api/json_v2.php/Market_Center.getHQNodeData?page=1&num=500&sort=symbol&asc=1&node=new_stock&_s_r_a=init"

module.exports = stock


###
    一些内部使用的函数
###
util =
    ###
        return '2013-11-18'
    ###
    getTime: ()->
        t = new Date()
        return "#{t.getFullYear()}-#{t.getMonth()+1}-#{t.getDate()}"