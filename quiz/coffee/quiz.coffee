answer = {}
score = 0
total = 0

$.ajaxSetup "error": (XMLHttpRequest,textStatus, errorThrown) ->
                          alert(textStatus)
                          alert(errorThrown)
                          alert(XMLHttpRequest.responseText)

$.ajaxSetup({cache: false})

getMovie = ->
   $.getJSON('/movie/0073486', {}, movieCallback)

movieCallback = (movie) ->
    $("#quizTemplate").tmpl(movie).appendTo "#quests"


loadTemplates = (callback) ->
  $.get('templates/headingTemplate.htm', (header) ->
      $('body').append(header)
  ) 

  $.get('templates/titleTemplate.htm', (header) ->
      $('body').append(header)
  ) 

  $.get('templates/imageTemplate.htm', (header) ->
      $('body').append(header)
  ) 

  $.get('templates/summaryTemplate.htm', (header) ->
      $('body').append(header)
      callback()
  ) 

getMovies = ->
   $.getJSON('/random', {}, moviesCallback)


moviesCallback = (data) ->
    clicked = false
    $("#quests").html('')
    answer = data.answer
    $("#headingTemplate").tmpl(data.answer).appendTo "#quests"
    $("#titleTemplate").tmpl(data).appendTo "#quests"
    $("#imageTemplate").tmpl(data).appendTo "#quests"
    $("#summaryTemplate").tmpl(data).appendTo "#quests"
    $('#score').html(score+"/"+total)
    

    $(".clicky").click ->
      unless clicked
        showAnswerAndUpdateScore(this)
        clicked = true
        
showAnswerAndUpdateScore = (source) ->
  message = "" 
  if source.id.indexOf(answer.choice) > 0
      message = "Correct!"
      score++
  else
      message = "Wrong! The correct answer was '#{answer.title}'"
  total++
  $('#score').html(score+"/"+total)
  newDiv = "<div class='span-24 last centered'>" +
             "<div class='span-23 answer centered'>#{message} <span id='nextQuestion' > Next Question</span></div>" +
           "</div>"
  $("#answerRow").html(newDiv) 
  $("#nextQuestion").click -> getMovies() 

allReady = ->
  loadTemplates(getMovies)

$(allReady)    
