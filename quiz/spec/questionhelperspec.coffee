qh = require '../lib/questionhelper'
require './fakerepo'
jasmine.DEFAULT_TIMEOUT_INTERVAL = 1000
        
describe "QuestionHelper", ->
    
    qhelp = new qh.QuestionHelper(new FakeRepo())

    it "can return three unique random movies", ->
        movies = []
        getReturned = false
        qhelp.getThreeRandomMovies (data) =>
            movies = data
            getReturned = true

        waitsFor -> getReturned is true
        runs ->
            expect(movies.length).toEqual 3
            expect(movies[0].movieID is movies[1].movieID ).toEqual false
            expect(movies[1].movieID is movies[2].movieID ).toEqual false
            expect(movies[2].movieID is movies[0].movieID ).toEqual false

    it "can remove common keywords from a list of movies", ->
        movies = []
        movies.push {movieID: "001", keywords: ["one", "two", "middle", "three", "four"]}
        movies.push {movieID: "002", keywords: ["two", "three", "four", "five"]}
        movies.push {movieID: "003", keywords: ["two", "free", "four", "mind"]}
        newMovies = qhelp.removeCommonKeywords(movies)
        expect(newMovies[0].keywords[0]).toEqual "one"
        expect(newMovies[0].keywords[1]).toEqual "middle"
        expect(newMovies[0].keywords.length).toEqual 2
        expect(newMovies[1].keywords[0]).toEqual "five"
        expect(newMovies[2].keywords[0]).toEqual "free"
        expect(newMovies[2].keywords[1]).toEqual "mind"

    it "can select a random keyword from a list of movies", ->
        movies = []
        movies.push {movieID: "001", title: "moviea", keywords: ["one", "two", "three", "four"]}
        movies.push {movieID: "002", title: "movieb", keywords: ["one2", "two2", "three2", "four2"]}
        movies.push {movieID: "003", title: "moviec", keywords: ["one3", "two3", "three3", "four3"]}

        answer = qhelp.generateAnswer movies
        expect(answer.keyword).toNotBe(null)
        expect(answer.title).toNotBe(null)
        expect(answer.choice).toNotBe(null)
        console.log answer
