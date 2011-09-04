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
  $.get('quizTemplate.htm', (template) ->
      $('body').append(template)
      callback()
  )

allReady = ->
  loadTemplates(getMovie)

$(allReady)    
