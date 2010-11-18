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
      if (msg.undo_path) {
        display += '<span class="undo-link"> (<a class="undo-link" href="' + msg.undo_path + '">undo</a>)</span>';
        undo_stack.push(msg.undo_path);
      }
      humanMsg.displayMsg(display);
    },
    error: function (XMLHttpRequest, textStatus, errorThrown) {
      humanMsg.displayMsg( 'Could not delete item, or maybe it has already been deleted' );
    }
  }, options || {}));
}

function processUndo(path, options) {
  $.ajax($.extend({
    type: "POST",
    url: path,
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
  $('a.undo-link[href=' + path + ']').parent('span').hide();
  undo_stack = jQuery.grep(undo_stack, function(e) { return e != path });
}

function asyncUndoBehaviour(options) {
  $('#humanMsgLog').click($.delegate({
    'a.undo-link': function(e) {
      processUndo(jQuery(e.target).attr('href'), options);
      return false;
    }
  }));
  jQuery.each(["Ctrl+Z", "Meta+Z"], function () {
    shortcut.add(this, function() {
      item = undo_stack.pop();
      if (item)
        processUndo(item, options)
      else
        humanMsg.displayMsg("Nothing to undo");
    });
  });
}

var undo_stack = new Array();

function onDeleteFormClick() {
  asyncDeleteForm($(this));

  // Assume success and remove item
  $(this).parent('td').parent('tr').remove();
  restripe();
  return false;
}

function destroyAndUndoBehaviour(type) {
  return function (){
    asyncUndoBehaviour({
      success: function(msg){
        humanMsg.displayMsg( msg.message );
        $.get('/admin/' + type + '/' + msg.obj.id, function(data) {
          $('table tbody').append(data);

          $('form.delete-item').unbind('submit', onDeleteFormClick);
          $('form.delete-item').submit(onDeleteFormClick);
          restripe();
        });
      },
    });

    $('form.delete-item').submit(onDeleteFormClick);
  }
}

