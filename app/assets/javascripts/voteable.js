$(document).on('turbolinks:load', function() {
  $('.vote-up, .vote-down').on('ajax:success', function(e) {
    var resource = e.detail[0];
    var resourceId = resource.id;

    $('.rating-' + resourceId).html(resource.rating);
  })
    .on('ajax:error', function (e) {
      var errors = e.detail[0];

      $.each(errors, function(index, value) {
        $('.answer-errors').html('<p>' + value + '</p>');
      })
    });
});
