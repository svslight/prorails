$(document).on('turbolinks:load', function(){
  $('.answers').on('click', '.edit-answer-link', function(e) {
    e.preventDefault();
    $(this).hide();
    var answerId = $(this).data('answerId');
    $('form#edit-answer-' + answerId).removeClass('hidden');
  })

  App.cable.subscriptions.create('AnswersChannel', {
    connected: function() {
      console.log('Answer Channel Connected!');
        return this.perform('follow', {question_id: gon.question_id });
    },
    received: function(data) {
      console.log(data);
      if (data.answer.author_id != gon.user_id) {
        return $('.answers').append(JST['templates/answer']({
          answer: data.answer,
          files: data.files,
          links: data.links
        }));
      }
    }
  });
});
