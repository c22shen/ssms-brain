$('.navbar').ready ->
  $("#about").click ->
    $("html,body").animate
      scrollTop: $(".features-section").offset().top
    , "slow"
    return
  $("#webapp").click ->
    $("html,body").animate
      scrollTop: $(".webapp-section").offset().top
    , "slow"
    return
  $("#team").click ->
    $("html,body").animate
      scrollTop: $(".team-section").offset().top
    , "slow"
    return
  $("#contact").click ->
    $("html,body").animate
      scrollTop: $(".contact-section").offset().top
    , "slow"
    return