exec = require('child_process').exec

module.exports =
    recommend: (req, res)->
        res.render 'stock/recommend', {

        }
    profit: (req, res)->
        #res.send('正在计算收益率请稍后')
        exec('coffee ../src/profit.coffee', (err, stdout, stderr)->
            res.send(err) if err
            res.send(stdout)
        )