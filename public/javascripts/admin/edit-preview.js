$(document).ready(function() {
  var form = $('form.new_post, form.edit_post, form.new_page, form.edit_page');
  
  if (form.length > 0) {
    var dest = window.location.href;
    if (!dest.match(/\/new$/)) {
      dest = dest.replace(/\/\d$/, '');
      dest = dest + '/new';
    }
    dest = dest + '/preview'

    var toggle_preview = function() {
      if ($('#preview').length == 0) {
        form.hide();
        form.after('<div id="preview"><h3>Your entry will be formatted like this:</h3><p>Use Ctrl-E to return to edit mode.</p><div class="content"><p>Please wait...</p></div></div>');

        jQuery.ajax({
          type: 'POST',
          data: form.serialize().replace(/&*_method=\w+&*/, ''),
          url: dest,
          error: function() {
            $('#preview .content').html('<p>Failed to generate preview. Toggle back to edit mode and check that all required fields are filled in and valid.</p>');
          },
          success: function(r) { 
            $('#preview .content').html(r);
          }
        });
      }
      else {
        $('#preview').remove();
        form.show();
      }
    }

    var ctrl_down = false;
    $(document).keydown(function(e) {
      if (e.which == 224 || e.which == 17) { ctrl_down = true; console.log('ctrl down'); } // Cmd || Ctrl
    });
    $(document).keyup(function(e) {
      if (e.which == 224 || e.which == 17) { ctrl_down = false; console.log('ctrl up'); }
    });
    $(document).keypress(function(e) {
      if (ctrl_down && e.which == 101) { toggle_preview(); } // 'E'
    });
  }
});
