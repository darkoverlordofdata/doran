task 'get', "test get", ->

    request = require 'request'
    url = 'https://raw.githubusercontent.com/darkoverlordofdata/doran/master/lib/init.coffee'
    request url, (error, response, body) ->
        console.log 'error:', error
        console.log 'statusCode:', response && response.statusCode
        # console.log 'body:', body
        
    