mysql = require('mysql')

config =
    host: 'hellofe.com'
    user: 'wangyuzju'
    password: 'wangyusi'
    database: 'czsc'


connection = mysql.createConnection config

###
    mysql connect configuation part
###


#connection.query "select * from tradingLimit",
#    (err, res, fields)->
#        return (console.error err) if err
#        console.log res
#        connection.end()
getDate = ()->
    time = new Date()
    return "#{time.getFullYear()}-#{time.getMonth()+1}-#{time.getDate()}"

# prefix for highlighting
DB = '\u001b[36m\u001b[1m[DB]\u001b[22m\u001b[39m'

db =

    save: (data, table='tradingLimit')->
        console.log "#{DB}[S] 正在保存..."

        timestamp = getDate()
        ###
            clear already existed data
        ###
        query = connection.query "DELETE FROM #{table} WHERE tradedate='#{timestamp}'", (err, result)->
            return (console.error err) if err
            console.log "#{DB}[D] deleted Rows: #{result.affectedRows}"


        ###
            prepare data for mutilple insertion
        ###
        values = []
        data.forEach((item, i)->
            delete item.pb
            delete item.per
            values.push( insert = [timestamp] )
            for key, value of item
                insert.push(value)
        )
        ###
            generate query string

        result = []
        Object.keys(set).forEach((item, i)->
            result.push('\''+item+'\'')
        )
        console.log result.join(',')
        ###
        query = connection.query "INSERT INTO #{table} (tradedate, symbol,code,name,trade,pricechange,changepercent,buy,sell,settlement,open,high,low,volume,amount,ticktime,mktcap,nmc,turnoverratio) VALUES ?", [values], (err, result)->
            return (console.error err) if err
            console.log "#{DB}[I] inserted Rows: #{result.affectedRows}"

        connection.end()

module.exports =  db