qr = require '../lib/quizrepo'
qh = require '../lib/questionhelper'
cr = require '../credentials'
jasmine.DEFAULT_TIMEOUT_INTERVAL = 10000

describe "QuestionHelper", ->
    
    repo = new qr.QuizRepo()
    repo.open()

    it "can return three random movies", ->
        movies = []
        getReturned = false
        waitsFor -> repo.ready
        runs ->
                qhelp = new qh.QuestionHelper(repo)
                qhelp.getThreeRandomMovies (data) =>
                    movies = data
                    getReturned = true

        waitsFor -> getReturned is true
        runs -> 
            expect(movies.length).toEqual 3
