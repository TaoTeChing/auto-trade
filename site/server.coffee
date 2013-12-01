express = require 'express'
ejs = require 'ejs'
routes = require './routes'
CONFIG = require './config'


app = express()
app.configure ()->
    app.set 'views', "#{__dirname}/views"
    # 使用ejs
    app.engine '.html', ejs.__express
    app.set('view engine', 'html')


    # 管理不同URL
    routes app


exports.start = ()->
    app.listen(CONFIG.port)
    console.log "Server Running On Port \"#{CONFIG.port}\" ..."