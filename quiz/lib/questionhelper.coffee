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
        for movieToCheck in movies
            @addDuplicatesAsArray movieToCheck, movies     
        @removeDuplicates movies
     

    addDuplicatesAsArray: (movieToCheck, allMovies) ->
        #add array to object to hold duplicates
        movieToCheck.duplicates = []
        
        for keyword in movieToCheck.keywords
            for otherMovie in allMovies        
                unless otherMovie is movieToCheck
                    if otherMovie.keywords.contains keyword
                        movieToCheck.duplicates.push keyword        

    removeDuplicates: (movies) ->
        for movie in movies
            movie.keywords = movie.keywords.complement movie.duplicates
            delete movie.duplicates
        return movies        

    generateAnswer: (movies) ->
        movieIndex = Math.floor( Math.random() * movies.length )
        movie = movies[movieIndex]
        keywordIndex = Math.floor( Math.random() * movie.keywords.length )
        answer = {}
        answer.keyword = movie.keywords[keywordIndex]
        answer.title = movie.title
        choices = ["A", "B", "C"]
        answer.choice = choices[movieIndex]
        return answer


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
