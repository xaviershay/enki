$(document).ready(function() {
  var form = $('.new_post, .edit_post, .new_page, .edit_page');
  var input_elements = form.find(':text, textarea');
  var fetch_preview = function() {
    var dest = window.location.href;

    if (!dest.endsWith('new')) {
      if (dest.match(/\/\d$/)) { 
        dest = dest.replace(/\/\d$/, '/new')
      }
      else { 
        dest = dest + '/new'
      }
    }

    jQuery.ajax({
      data: form.serialize(),
      url:  dest,
      timeout: 2000,
      error: function() {
        console.log("Failed to submit");
      },
      success: function(r) { 
        if ($('#preview').length == 0) {
          form.after('<div id="preview"><h3>Your entry will be formatted like this: <span>(pause live preview)</span></h3><div class="content"></div></div>');
        }
        $('#preview .content').html(r);
      }
    });
  };

  $('#preview h3 span').livequery('click', function() {
    var text = $(this).html();
    if (text.match(/pause/)) {
      $(this).html(text.replace(/pause/, 'start'));
      $('#preview .content').fadeTo(100, 0.3);
    }
    else {
      $(this).html(text.replace(/start/, 'pause'));
      $('#preview .content').fadeTo(100, 1);
      fetch_preview();
    }
  });

  input_elements.keyup(function() {
    if ($('#preview h3 span').html().match(/pause/)) {
      fetch_preview.only_every(1000);
    }
  });

  fetch_preview();
});
