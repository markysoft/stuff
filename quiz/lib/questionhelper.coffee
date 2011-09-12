class QuestionHelper

    constructor:(repo) ->
        @repo = repo
        @movies = []

    getThreeRandomMovies: (callback) ->
        indexes = @getThreeUniqueRandomNumbers(@repo.totalMovies)
        @repo.getAllMovieIds (ids) => @getSelectedMovies indexes, ids, callback

    getThreeUniqueRandomNumbers: (records) ->
        numbers = []
        while numbers.length < 3
            number = Math.floor(Math.random() * records)
            numbers.push number unless numbers.contains number
        return numbers

    getSelectedMovies: (indexes, ids, callback) ->
        selectedMovies = []
        for index in indexes
            selectedMovies.push ids[index].movieID
        @repo.getMovies selectedMovies, callback

    removeCommonKeywords: (movies) ->
        filteredKeywords = []
        for outerMovie in movies

            filtered = []
            for movie in movies
                unless movie is outerMovie
                   uniqueKeywords = outerMovie.keywords.complement movie.keywords
                   filtered.merge uniqueKeywords
            filteredKeywords.push filtered

        @replaceKeywords(movies, filteredKeywords)

    replaceKeywords: (movies, newKeywords) ->
        for index, keywords of newKeywords
            movies[index].keywords = keywords
        return movies


# add convenience functions to Array class
Array::contains = (item) ->
    i = this.length
    while i--
        return true if this[i] is item
    false

Array::complement = (items) ->
        uniqueItems = []
        for item in this
            unless items.contains item
                uniqueItems.push item
        return uniqueItems

Array::merge = (other) -> Array::push.apply this, other

root = exports ? window
root.QuestionHelper = QuestionHelper
