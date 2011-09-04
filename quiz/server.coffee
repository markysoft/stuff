express = require 'express'
jqtpl = require 'jqtpl'
qr = require './lib/quizrepo'
creds = require './credentials'

repo = new qr.QuizRepo()
repo.open()
app = express.createServer()
 
# Setup configuration
coffeeDir = __dirname + '/coffee'
publicDir = __dirname + '/public'
app.use express.compiler(src: coffeeDir, dest: publicDir, enable: ['coffeescript'])
app.use express.static(publicDir)

app.set("view engine", "html")
app.register(".html", require("jqtpl").express)
 
# App Routes
app.get '/', (req, res) ->
  res.render 'index.html', { title: 'Express with Coffee' }

app.get '/quiz', (req, res) ->
    res.render 'quiz.html', {test: {name: 'Testy'}}


app.get '/movie/:id' , (req, res) ->
    repo.getMovie(req.params.id, (movie)=> res.send movie if movie)
 

# Listen
app.listen 3000
console.log "Express server listening on port %d", app.address().port
