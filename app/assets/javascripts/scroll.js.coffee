$('.navbar').ready ->
  $("#about").click ->
    $("html,body").animate
      scrollTop: $(".features-section").offset().top
    , "slow"
    $(".navbar-toggle").click()
    return
  $("#webapp").click ->
    $("html,body").animate
      scrollTop: $(".webapp-section").offset().top
    , "slow"
    $(".navbar-toggle").click()
    return
  $("#team").click ->
    $("html,body").animate
      scrollTop: $(".team-section").offset().top
    , "slow"
    $(".navbar-toggle").click()
    return
  $("#contact").click ->
    $("html,body").animate
      scrollTop: $(".contact-section").offset().top
    , "slow"
    $(".navbar-toggle").click()
    return
  $("#contact-btn").click ->
    $("html,body").animate
      scrollTop: $(".contact-section").offset().top
    , "slow"
    $(".navbar-toggle").click()
    return