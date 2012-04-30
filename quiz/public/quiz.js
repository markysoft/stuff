(function() {
  var allReady, answer, getMovie, getMovies, loadTemplates, movieCallback, moviesCallback, score, showAnswerAndUpdateScore, total;

  answer = {};

  score = 0;

  total = 0;

  $.ajaxSetup({
    "error": function(XMLHttpRequest, textStatus, errorThrown) {
      alert(textStatus);
      alert(errorThrown);
      return alert(XMLHttpRequest.responseText);
    }
  });

  $.ajaxSetup({
    cache: false
  });

  getMovie = function() {
    return $.getJSON('/movie/0073486', {}, movieCallback);
  };

  movieCallback = function(movie) {
    return $("#quizTemplate").tmpl(movie).appendTo("#quests");
  };

  loadTemplates = function(callback) {
    $.get('templates/headingTemplate.htm', function(header) {
      return $('body').append(header);
    });
    $.get('templates/titleTemplate.htm', function(header) {
      return $('body').append(header);
    });
    $.get('templates/imageTemplate.htm', function(header) {
      return $('body').append(header);
    });
    return $.get('templates/summaryTemplate.htm', function(header) {
      $('body').append(header);
      return callback();
    });
  };

  getMovies = function() {
    return $.getJSON('/random', {}, moviesCallback);
  };

  moviesCallback = function(data) {
    var clicked;
    clicked = false;
    $("#quests").html('');
    answer = data.answer;
    $("#headingTemplate").tmpl(data.answer).appendTo("#quests");
    $("#titleTemplate").tmpl(data).appendTo("#quests");
    $("#imageTemplate").tmpl(data).appendTo("#quests");
    $("#summaryTemplate").tmpl(data).appendTo("#quests");
    $('#score').html(score + "/" + total);
    return $(".clicky").click(function() {
      if (!clicked) {
        showAnswerAndUpdateScore(this);
        return clicked = true;
      }
    });
  };

  showAnswerAndUpdateScore = function(source) {
    var message, newDiv;
    message = "";
    if (source.id.indexOf(answer.choice) > 0) {
      message = "Correct!";
      score++;
    } else {
      message = "Wrong! The correct answer was '" + answer.title + "'";
    }
    total++;
    $('#score').html(score + "/" + total);
    newDiv = "<div class='span-24 last centered'>" + ("<div class='span-23 answer centered'>" + message + " <span id='nextQuestion' > Next Question</span></div>") + "</div>";
    $("#answerRow").html(newDiv);
    return $("#nextQuestion").click(function() {
      return getMovies();
    });
  };

  allReady = function() {
    return loadTemplates(getMovies);
  };

  $(allReady);

}).call(this);
