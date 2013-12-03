app = require('./server')
CONFIG = require './config'
server = require('http').Server(app)
io = require('socket.io').listen(server)

#server = require './server'
io.on('connection', (socket)->
#    socket.on('event', (data)->
#        console.log(data);
#    )
#    socket.on('disconnect', ()->
#        console.log "websocket disconnect".prompt;
#    )
#    `
#    socket.emit('news', { hello: 'world' });
#    socket.on('test', function (data) {
#        console.log(data);
#    });
#    `
    socket.emit('news', {hello: 'world!'});
    socket.on('test', (data)->
        console.log(data)
    );
)
io.set('destroy upgrade', false)

server.listen(CONFIG.port)
console.log "Server Running On Port \"#{CONFIG.port}\" ...".info