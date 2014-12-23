_http = require('http')
_url = require('url')
_path = require('path')
_fs = require('fs')
_port = process.env.PORT

_server = _http.createServer (request, response) ->
    _templates_prefix = _path.join process.cwd(), 'html'
    _static_prefix = _path.join process.cwd(), 'static'
    _uri = _url.parse(request.url).pathname
    _filename = _path.join _templates_prefix,_uri

    _content_types_by_extension =
        '.html': 'text/html'
        '.css': 'text/css'
        '.js': 'text/javascript'
        
    if _fs.existsSync _filename
        if _fs.statSync(_filename).isDirectory
            _filename += 'index.html'
            
    _ext = _path.extname(_filename)
    if _ext != '.html'
        _filename = _path.join _static_prefix, _uri

    _fs.exists _filename, (exists) ->
        if not exists
            _ct =
                'Content-Type': 'text/plain'
            response.writeHead(404, {'Content-Type': 'text/plain'})
            response.write '404 Not Found\n'
            return response.end()
            

        _fs.readFile _filename, 'binary', (err, file) ->
            if err
               response.writeHead 500, {'Content-Type': 'text/plain'}
               response.write err + '\n'
               return response.end()
               
            _headers = {}
            _content_type = _content_types_by_extension[_path.extname _filename]

            if _content_type
                _headers['Content-Type'] = _content_type

            response.writeHead 200, _headers
            response.write file, 'binary'
            return response.end()

_server.listen parseInt(_port, 10)

console.log 'Static file server running at\n => http://localhost:' + _port + '/\nCTRL + C to shutdown'
