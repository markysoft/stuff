class QuizRepo

    constructor: () ->
        @ready = false
        @initialiseClient()
        @movieCollection = null

    initialiseClient: ->       
        mongo = require 'mongodb'
        server = new mongo.Server "staff.mongohq.com", 10028, {auto_reconnect:true}
        @client = new mongo.Db 'quiz', server
        console.log "initialised client #{@client}"

    open: ->
        @client.open (err, database) => 
            @client.authenticate Credentials.user,Credentials.password, @setupRepository
                                        
    close: ->
        @client.close()

    setupRepository: (err) =>
        @checkSucceeded err 
        @loadCollections()
        @getTotalMovies (total) =>
            @totalMovies = total
            @ready = true

    getTotalMovies: (callback) ->
        @collection.count (err, result) => 
            callback result

    loadCollections: => 
        @client.collection 'keyword_quiz.movie_infos', (dbErr, collection) =>
            @checkSucceeded dbErr 
            @collection = collection 

    checkSucceeded: (err) => throw "Mongo Error: '#{err}'" if err != null    

    getMovie:  (movieId, callback) ->  
        @collection.find({movieID: movieId}).nextObject (err, result) => 
            @checkSucceeded err
            callback result  
            
    getMoviesByGenre: (genre, callback) =>
        @collection.find({genres: genre}).toArray (err, results) => 
            @checkSucceeded err
            callback results     

    getMovieAt:  (position, callback) ->  
        @collection.find().skip(position).nextObject (err, result) => 
            @checkSucceeded err
            callback result  
                                   
    
                
root = exports ? window
root.QuizRepo = QuizRepo

#qr = require './code.coffee'
#repo = new qr.QuizRepo()
#repo.getMovieById 0111161


#setTimeout (=> console.log repo.totalMovies), 1500
#setTimeout (=> repo.getMovieAt(249, (movie)=> console.log "movie at 249 #{movie.title}" if movie)), 2000
#setTimeout (=> repo.getMovie("0110912", (movie)=> console.log movie.title if movie)), 2200
#setTimeout (=> repo.getMoviesByGenre "Horror", (movies) => console.log "#{movie.movieID}: #{movie.title} #{movie.genres}" for movie in movies), 2500
#setTimeout (=> repo.close()), 4500