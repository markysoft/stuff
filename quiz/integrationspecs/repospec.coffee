qr = require '../lib/quizrepo'
qh = require '../lib/questionhelper'
cr = require '../credentials'
jasmine.DEFAULT_TIMEOUT_INTERVAL = 10000

describe "Quiz Repository", ->

    repo = new qr.QuizRepo()
    repo.open()

    it "can return the total number of movies", ->
        getReturned = false
        total = 0

        waitsFor -> repo.ready
        runs ->
            repo.getTotalMovies (data) =>
                getReturned = true
                total = data
        waitsFor -> getReturned is true
        runs -> expect(total).toEqual 250
        
    it "can return a list of all movie ids", ->
        getReturned = false
        movieIds = []

        waitsFor -> repo.ready
        runs ->
            repo.getAllMovieIds (data) =>
                movieIds = data
                getReturned = true
        waitsFor -> getReturned is true
        runs -> 
            expect(movieIds.length).toEqual 250
     
    it "can return a list of all movie posters", ->
        getReturned = false      
        moviePosters = []
        waitsFor -> repo.ready
        runs ->
            repo.getAllMoviePosters (data) =>
                moviePosters = data
                getReturned = true
        waitsFor -> getReturned is true
        runs -> 
            expect(moviePosters.length).toEqual 250


    it "can retrieve a movie by id", ->
       getReturned = false
       movie = null

       waitsFor -> repo.ready
       runs ->
           repo.getMovie "0110912",
               (data)=>
                   getReturned = true
                   movie = data
                   #console.log movie.title if movie

       waitsFor -> getReturned is true
       runs -> expect(movie.title).toEqual "Pulp Fiction"

    it "can retrieve movies by list of id", ->
       getReturned = false
       movies = []

       waitsFor -> repo.ready
       runs ->
           repo.getMovies ["0110912", "0111161"],
               (data)=>
                   getReturned = true
                   movies = data

       waitsFor -> getReturned is true
       runs -> expect(movies.length).toEqual 2

    it "can retrieve a movie by index", ->
        getReturned = false
        movie = null
        waitsFor -> repo.ready
        runs ->
            repo.getMovieAt "0",
                (data) =>
                    getReturned = true
                    movie = data
                    #console.log movie.title if movie

        waitsFor -> getReturned is true
        runs -> expect(movie.title).toEqual "The Shawshank Redemption"

    it "can retrieve movies by genre", ->
       getReturned = false
       movies = null

       waitsFor -> repo.ready
       runs ->
           repo.getMoviesByGenre "Horror",
               (data)=>
                   getReturned = true
                   movies = data

       waitsFor -> getReturned is true
       runs -> 
            expect(movies.length).toEqual  6
            repo.close()

