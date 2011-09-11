class FakeRepo
    constructor: ->
        @ready = true
        @totalMovies = 5

    getAllMovieIds: (callback) ->
        callback [
            {movieID: "001"},
            {movieID: "002"},
            {movieID: "003"},
            {movieID: "004"},
            {movieID: "005"}
        ]

    getMovies: (ids, callback) ->
        movies = []
        for id in ids
            movies.push @createFakeMovie id
        callback movies

    createFakeMovie: (id) ->
        {movieID: id, title: "Movie#{id}"}

global.FakeRepo = FakeRepo
