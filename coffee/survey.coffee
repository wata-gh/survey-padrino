$ ->
  Survey.question = {}
  $ '.ui.button.red.del'
  .on 'click', ->
    sid = $(this).data 'sid'
    $ '.ui.basic.modal.del'
      .modal {
        closable: false,
        onApprove: ->
          location.href = "delete"
      }
      .modal 'show'
  q_h = Handlebars.compile($('#q-tmpl').html())

  Handlebars.registerHelper 'select', (v, o) ->
    $el = $('<select />').html(o.fn(this))
    $el.find('[value="' + v + '"]').attr {'selected': 'selected'}
    $el.html()

  Survey.question.add = (v) ->
    $('#add-q-pos').append(q_h v)
    $('select').dropdown()

  $('.add-q').on 'click', Survey.question.add
  $(document).on 'click', '.del-q', ->
    id = $(this).data 'id'
    $("#q-#{id}").fadeOut 200, ->
      $(this).remove()
