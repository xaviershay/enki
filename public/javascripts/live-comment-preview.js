$(function() { // onload
  var comment_form = $('#new_comment')
  var input_elements = comment_form.find(':text, textarea')
  var fetch_comment_preview = function() {
    var dest = window.location.href;
    dest = dest.split('#')[0];
    dest = dest.split('?')[0];

    if (!dest.endsWith('comments'))
      dest += '/comments';

    jQuery.ajax({
      data: comment_form.serialize(),
      url:  dest + '/new',
      timeout: 2000,
      error: function() {
        console.log("Failed to submit");
      },
      success: function(r) { 
        if ($('#comment-preview').length == 0) {
          comment_form.after('<h2>Your comment will look like this:</h2><div id="comment-preview"></div>')
        }
        $('#comment-preview').html(r)
      }
    })
  }

  input_elements.keyup(function () {
    fetch_comment_preview.only_every(1000);
  })
  if (input_elements.any(function() { return $(this).val().length > 0 }))
    fetch_comment_preview();
})  
