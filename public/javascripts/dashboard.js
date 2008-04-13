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
})
