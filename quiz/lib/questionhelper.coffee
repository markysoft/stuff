class QuestionHelper

    constructor:(repo) ->
        @repo = repo
        @movies = []

    getThreeRandomMovies: (callback) ->
        indexes = @getThreeUniqueRandomNumbers(250)
        @repo.getAllMovieIds (ids) => @getSelectedMovies indexes, ids, callback

    getThreeUniqueRandomNumbers: (records) ->
        numbers = []
        while numbers.length < 3
            number = Math.floor(Math.random() * records)
            numbers.push number unless @contains(numbers, number)
        return numbers

    contains: (array, item) ->
          i = array.length
          while i--
              return true if array[i] is item
          false

    getSelectedMovies: (indexes, ids, callback) ->
        selectedMovies = []
        for index in indexes
            selectedMovies.push ids[index].movieID
        @repo.getMovies selectedMovies, callback

root = exports ? window
root.QuestionHelper = QuestionHelper
