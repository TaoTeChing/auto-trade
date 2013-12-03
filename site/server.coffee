express = require 'express'
ejs = require 'ejs'
routes = require './routes'

app = express()
app.configure ()->
    app.set 'views', "#{__dirname}/views"
    # 使用ejs
    app.engine '.html', ejs.__express
    app.set('view engine', 'html')


    # 管理不同URL
    routes app


module.exports = app