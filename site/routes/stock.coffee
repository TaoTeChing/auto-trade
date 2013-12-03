exec = require('child_process').exec


module.exports =
    recommend: (req, res)->
        res.render 'stock/recommend', {

        }

    filter: (req, res)->
        console.log "Receive request #{req.path}, start filterring ...".info
        if !(filterDate = req.query.date)
            return res.send('请输入日期，进行筛选')

        res.render 'stock/filter',
            date: filterDate

        child = exec("coffee ../src/auto_trade.coffee #{filterDate}", (err)->
            if err
                if (socket = global.socketClients)
                    socket.emit('message', err)
                    socket.disconnect()
            # 最后成功的回调, stdout是执行完之后才输出, 而不是立即输出
            # res.send(err) if err
        )
        child.stdout.on 'data', (data)->
            console.log(data.trim().error)
            if (socket = global.socketClients)
                socket.emit('message', data.trim())
        child.on 'close', ()->
            if (socket = global.socketClients)
                socket.emit('exit')
                socket.disconnect()

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