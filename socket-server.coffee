_ws = require('nodejs-websocket')

_server = _ws.createServer (_connection) ->
    console.log('New connection')
    _connection.on 'text', (_str) ->
        console.log('Received '+_str)
        _connection.sendText(_str.toUpperCase()+ '!!!')

    _connection.on 'close', (_code, _reason) ->
        console.log('Connection closed')

_server.listen(process.env.PORT)
