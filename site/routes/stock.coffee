exec = require('child_process').exec


module.exports =
    recommend: (req, res)->
        res.render 'stock/recommend', {

        }

    filter: (req, res)->
        console.log "Receive request #{req.path}, start filterring ..."
        return res.render 'stock/filter'

        child = exec('coffee ../src/auto_trade.coffee', (err)->
            # 最后成功的回调, stdout是执行完之后才输出, 而不是立即输出
            # res.send(err) if err
        )
        child.stdout.on 'data', (data)->
            console.log(data.trim())
        child.on 'close', ()->



    profit: (req, res)->
        console.log "Receive request #{req.path}"
        #res.send('正在计算收益率请稍后')
        child = exec('coffee ../src/profit.coffee', (err, stdout, stderr)->
            console.log err if err
            # res.send(err) if err
            # res.send(stdout)
        )

        child.on('exit', ()->
            res.send('计算完成!')
        )