$.ajaxPrefilter( (options, originalOptions, xhr) ->
  if !options.crossDomain
    token = $('meta[name="csrf-token"]').attr 'content'
    if token
      xhr.setRequestHeader 'X-CSRF-Token', token
)
$ 'select'
  .dropdown()

$ '.message .close'
.on 'click', ->
  $ this
  .closest '.message'
  .transition 'fade'

reg = false
sid = null

$ '.ui.modal.reg'
  .modal 'setting', {
    onHide: ->
      if reg
        location.href = "#{location.href}survey/#{sid}/edit"
    onApprove: ->
      n = $('#name').val()
      $.post 'api/survey', {name: n}
        .done (r) ->
          reg = r.is_success == 1
          sid = r.results.id
          $ '.ui.modal'
            .modal 'hide'
      false
  }
$ '.new'
  .on 'click', ->
    $ '.ui.modal.reg'
      .modal('show')

$ '.completed.step'
.on 'click', ->
  location.href = $(this).data('url')
