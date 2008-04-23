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

function destroyAndUndoBehaviour(type) {
  return function (){
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
             $.get('/admin/' + type + '/' + msg.obj.id, function(data) {
               $('table tbody').append(data);
               restripe();
             });
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
       $(this).parent('td').parent('tr').remove();

       // Redo zebra striping
       restripe();
       return false;
    });
  }
}  

