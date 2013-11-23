http = require "http"
iconv = require 'iconv-lite' # convert encoding
BufferHelper = require 'bufferhelper'
db = require "#{__dirname}/db"
FormData = require 'form-data'

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
        console.log "[connected] #{url.cyan.underline}"

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

    获取股价的平均价格

###
stock.averagePrice = (id, start = util.getTime(), sep)->
    data =
        id: id
        date: start
        len: sep

    dataStr = JSON.stringify(data)
    console.log dataStr

    options =
        hostname: 'uclink.org'
        path: '/getAvg.php'
        method: 'POST'
        port: 80
        headers:
            'Content-Type': 'application/x-www-form-urlencoded',
            'Content-Length': dataStr.length


    req = http.request options, (res)->
        # console.log res
        res.setEncoding('utf-8')
        res.on('data', (chunk)->
            console.log chunk
        )

    req.on('error', (err)->
        console.log err
    )

    req.write(dataStr)
    req.end()
    #form.pipe(req)
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