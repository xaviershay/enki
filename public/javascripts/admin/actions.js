$(document).ready(function () {
  $('form.undo-item').submit(function () {
     $.ajax({
       type: "POST",
       url: $(this).attr('action'),
       beforeSend: function(xhr) {
         xhr.setRequestHeader("Accept", "application/json");
       },
       dataType: 'json',
       success: function(msg){
         humanMsg.displayMsg( msg.message);
       },
       error: function (XMLHttpRequest, textStatus, errorThrown) {
         humanMsg.displayMsg( 'Could undo action' );
       }
     });

     // Assume success and remove comment
     $(this).parent('td').parent('tr').remove();

     // Redo zebra striping
     restripe();
     return false;
  });
})
