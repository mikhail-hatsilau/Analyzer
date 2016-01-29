express = require 'express'
path = require 'path'
analyzer = require './analyzer/analyzer'
exec = require('child_process').exec

app = express()

app.use express.static(__dirname)

app.get '/chart', (req, resp) ->
  resp.json analyzer.analyzejs(req.query.path)

app.listen 3000, ->
  console.log 'Listening 3000 port'
  exec('firefox http://localhost:3000', (error) ->
    if error then console.log error
  )
