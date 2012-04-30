express = require 'express'
jqtpl = require 'jqtpl'
qr = require './lib/quizrepo'
qh = require './lib/questionhelper'
creds = require './credentials'

repo = new qr.QuizRepo()
repo.open()
qhelp = new qh.QuestionHelper(repo)
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
    res.render 'quiz.html', { title: 'Getting First Question...' }


app.get '/movie/:id' , (req, res) ->
    repo.getMovie(req.params.id, (movie)=> res.send movie if movie)

app.get '/random', (req, res) ->
    qhelp.getThreeRandomMovies (data) => 
        movies = data
        console.log "got movies, removing common keywords"
        for movie in movies
            movie.poster = movie.poster.replace('http://ia.media-imdb.com/images/M', 'images')
        movies = qhelp.removeCommonKeywords(movies)
        answer = qhelp.generateAnswer movies
        res.send {movies: movies, answer: answer}
 
# Listen
app.listen 3000
console.log "Express server listening on port %d", app.address().port
