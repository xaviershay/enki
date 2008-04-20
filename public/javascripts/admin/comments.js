$(document).ready(function (){
  $('form.delete-comment').submit(function () {
     $.ajax({
       type: "DELETE",
       url: $(this).attr('action'),
       beforeSend: function(xhr) {
         xhr.setRequestHeader("Accept", "application/json");
       },
       dataType: 'json',
       success: function(msg){
         humanMsg.displayMsg( 'Deleted comment by ' + msg.author );
       },
       error: function (XMLHttpRequest, textStatus, errorThrown) {
         humanMsg.displayMsg( 'Could not delete comment, or maybe it has already been deleted' );
       }
     });

     // Assume success and remove comment
     $(this).parent('td').parent('tr').remove();

     // Redo zebra striping
     $('table tr:odd').removeClass('alt'); 
     $('table tr:even').addClass('alt'); 
     return false;
  });
});
