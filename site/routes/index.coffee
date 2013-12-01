routers =
    index: (req, res)->
        #res.send('hello index!')
        res.render('index', {
            title: '首页'
        })


routers.stock = require('./stock')


module.exports =  (app)->
    app.get('/', routers.index)

    for key, value of routers.stock
        app.get("/stock/#{key}", value)