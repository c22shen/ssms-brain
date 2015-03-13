$ ->
  $('.artGroup.flip').hover (->
    # alert 'xiao'
    $(this).find('.artwork').addClass 'theFlip'
    return
  ), ->
    $(this).find('.artwork').removeClass 'theFlip'
    return
  return