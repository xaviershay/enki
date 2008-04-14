function extractId(obj) {
  tokens = obj.attr('id').split('-');
  return tokens[tokens.length-1];
}

$(document).ready(function (){
  $('.comment-body').hide();

  $('.comment-link').click (function() {
    comment_body_id = '#comment-body-' + extractId($(this));
    
    $('.comment-body').not(comment_body_id).hide();
    $(comment_body_id).toggle();

    return false;
  })

  // Load recent commits
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
})
