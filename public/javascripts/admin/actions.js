$(document).ready(function () {
  $('form.undo-item').submit(function () {
    asyncDeleteForm($(this), {
      type: "POST",
      success: function (msg) {
        humanMsg.displayMsg( msg.message );
      },
      error: function (XMLHttpRequest, textStatus, errorThrown) {
        humanMsg.displayMsg( 'Could not undo action' );
      }
    });

    // Assume success and remove item
    $(this).parent('td').parent('tr').remove();
    restripe();
    return false;
  });
})
