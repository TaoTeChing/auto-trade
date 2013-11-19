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

module.exports = stock