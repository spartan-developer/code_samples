$ ->
  previewTimeout = null
  $('form.edit_card textarea').keyup ->
    textarea = this
    cardText = $(this).val()
    cancel previewTimeout
    previewTimeout = delay 1000, ->
      $.post '/cards/preview', raw: cardText, (processed) ->
        if /question/.test textarea.id
          $('#question').html processed
        else if /answer/.test textarea.id
          $('#answer').html processed
        SyntaxHighlighter.highlight()

  $('#editCard').click ->
    $(this).fadeOut()
    $('form.edit_card').slideDown()

  $('form.edit_card .btn-danger').click ->
    $('form.edit_card').slideUp()
    $('#editCard').fadeIn()

  $('a[data-toggle="tab"]').on 'shown', ->
    if this.innerHTML == 'Answer'
      $('form.edit_card textarea#card_question').hide()
      $('form.edit_card textarea#card_answer').show()
    else
      $('form.edit_card textarea#card_answer').hide()
      $('form.edit_card textarea#card_question').show()
