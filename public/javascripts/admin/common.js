jQuery.delegate = function(rules) {
  return function(e) {
    var target = $(e.target);
    for (var selector in rules)
      if (target.is(selector)) return rules[selector].apply(this, $.makeArray(arguments));
  }
}

function restripe() {
  $('table tr:odd').removeClass('alt'); 
  $('table tr:even').addClass('alt'); 
}

function asyncDeleteForm(obj, options) {
  $.ajax($.extend({
    type: "DELETE",
    url: obj.attr('action'),
    beforeSend: function(xhr) {
      xhr.setRequestHeader("Accept", "application/json");
    },
    dataType: 'json',
    success: function(msg){
      display = msg.undo_message
      if (msg.undo_path)
        display += '<span class="undo-link"> (<a class="undo-link" href="' + msg.undo_path + '">undo</a>)</span>';
      humanMsg.displayMsg(display);
    },
    error: function (XMLHttpRequest, textStatus, errorThrown) {
      humanMsg.displayMsg( 'Could not delete item, or maybe it has already been deleted' );
    }
  }, options || {}));
}

function asyncUndoBehaviour(options) {
  $('#humanMsgLog').click($.delegate({
    'a.undo-link': function(e) { 
      link = jQuery(e.target);
      $.ajax($.extend({
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
       }, options || {}));  

       // Assume success and remove undo link
       link.parent('span').hide();
       return false;
    }
  }));
}

function destroyAndUndoBehaviour(type) {
  return function (){
    asyncUndoBehaviour({
      success: function(msg){
        humanMsg.displayMsg( msg.message );
        $.get('/admin/' + type + '/' + msg.obj.id, function(data) {
          $('table tbody').append(data);
          restripe();
        });
      },
    });

    $('form.delete-item').submit(function () {
       asyncDeleteForm($(this));

       // Assume success and remove item
       $(this).parent('td').parent('tr').remove();
       restripe();
       return false;
    });
  }
}  

