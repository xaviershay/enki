$(document).ready(function() {
  var form = $('.new_post, .edit_post, .new_page, .edit_page');
  var input_elements = form.find(':text, textarea');
  var textarea = $('#post_body, #page_body');
  var fetch_preview = function() {
    var dest = window.location.href;

    if (!dest.endsWith('new')) {
      dest = dest.replace(/\/\d$/, '');
      dest = dest + '/new';
    }
    dest = dest + '/preview'

    jQuery.ajax({
      type: 'POST',
      data: form.serialize().replace(/&*_method=\w+&*/, ''),
      url:  dest,
      timeout: 2000,
      error: function() {
        console.log("Failed to submit");
      },
      success: function(r) { 
        if ($('#preview').length == 0) {
          form.after('<div id="preview"><h3>Your entry will be formatted like this:</h3><p><span>pause live preview</span></p><div class="content"></div></div>');
        }
        $('#preview .content').html(r);
        
        var target_textarea_height = $('#preview').height() - 50;
        if (target_textarea_height <= 450) {
          target_textarea_height = 450;
        }
        textarea.height(target_textarea_height);
      }
    });
  };

  $('#preview > p span').livequery('click', function() {
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
    if ($('#preview > p span').html().match(/pause/)) {
      fetch_preview.only_every(1000);
    }
  });

  fetch_preview();
});
