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
            console.log "repo ready"
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
            
    getMovies:  (movieIds, callback) ->
        @collection.find({movieID: {"$in" : movieIds}}).toArray (err, results) =>
            @checkSucceeded err
            callback results

    getMoviesByGenre: (genre, callback) =>
        @collection.find({genres: genre}).toArray (err, results) =>
            @checkSucceeded err
            callback results

    getMovieAt:  (position, callback) ->
        @collection.find().skip(position).nextObject (err, result) =>
            @checkSucceeded err
            callback result
                
    getAllMovieIds: (callback) ->
        @collection.find({},{"movieID" : 1}).toArray (err, results) =>
            @checkSucceeded err
            callback results

                
    getAllMoviePosters: (callback) ->
        @collection.find({},{"poster" : 1}).toArray (err, results) =>
            @checkSucceeded err
            callback results            
            
root = exports ? window
root.QuizRepo = QuizRepo
