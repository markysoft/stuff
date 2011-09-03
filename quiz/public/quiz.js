(function() {
  var allReady, getMovie, loadTemplates, movieCallback;
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
    return $.get('quizTemplate.htm', function(template) {
      $('body').append(template);
      return callback();
    });
  };
  allReady = function() {
    return loadTemplates(getMovie);
  };
  $(allReady);
}).call(this);
