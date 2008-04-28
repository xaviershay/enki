function extractId(obj) {
  tokens = obj.attr('id').split('-');
  return tokens[tokens.length-1];
}

$(document).ready(function (){
//  $('.comment-body').hide();

  $('.comment-link').click (function() {
    comment_body_id = '#comment-body-' + extractId($(this));
    
    $('.comment-body').not(comment_body_id).hide();
    $(comment_body_id).toggle();

    return false;
  })

  $('#humanMsgLog').click($.delegate({
    'a.undo-link': function(e) { 
      link = jQuery(e.target);
      $.ajax({
        type: "POST",
        url: link.attr('href'),
         beforeSend: function(xhr) {
           xhr.setRequestHeader("Accept", "application/json");
         },
         dataType: 'json',
         success: function(msg){
           humanMsg.displayMsg( msg.message );
         },
         error: function (XMLHttpRequest, textStatus, errorThrown) {
           humanMsg.displayMsg( 'Could not undo' );
         }
       });  

       // Assume success and remove undo link
       link.parent('span').hide();
       return false;
    }
  }));

  $('form.delete-item').submit(function () {
     $.ajax({
       type: "DELETE",
       url: $(this).attr('action'),
       beforeSend: function(xhr) {
         xhr.setRequestHeader("Accept", "application/json");
       },
       dataType: 'json',
       success: function(msg){
         humanMsg.displayMsg( msg.undo_message + '<span class="undo-link"> (<a class="undo-link" href="' + msg.undo_path + '">undo</a>)</span>');
       },
       error: function (XMLHttpRequest, textStatus, errorThrown) {
         humanMsg.displayMsg( 'Could not delete item, or maybe it has already been deleted' );
       }
     });

     // Assume success and remove comment
     comment_link_id = '#comment-link-' + extractId($(this));
     $(comment_link_id).remove();
     $(this).parent('div').parent('div').remove();

     // Redo zebra striping
     return false;
  });

  // Load recent commits
  // Disable this by default because the server side proxy ties up too many resources
  // TODO: Find a way to do this without hitting the server
  /*
  jQuery.getFeed({
    url: '/admin/proxy/http://gitorious.org/projects/enki/repos/mainline.atom', // github feed is invalid :(
    success: function(feed) {
      $('#recent-comments').after("<div id='recent-commits' class='panel'><h2>Recent commits</h2><p>Keep a sharp eye out for security updates</p></div>")
         
      html = "<ul>";
      for(var i = 0; i < feed.items.length && i < 7; i++) {
        var item = feed.items[i];

        truncated_length = 60
        truncated_title = item.title.substring(0, truncated_length);
        if (item.title.length > truncated_length)
          truncated_title += '&hellip;';

        className = i == 0 ? 'first item' : 'item';
        html += '<li class="' + className + '">';
        html += '<h3><a href="' + item.link + '" title="' + item.title + '">' + truncated_title + "</a></h3>";
        html += '</li>';
      }
      html += '</ul>';
      $('#recent-commits').append(html);
    }
  });
  */
})
