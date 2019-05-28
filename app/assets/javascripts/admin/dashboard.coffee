$(document).ready ->
  (($) ->
    'use strict'
    # Start of use strict
    # Toggle the side navigation
    $('#sidebarToggle, #sidebarToggleTop').on 'click', (e) ->
      $('body').toggleClass 'sidebar-toggled'
      $('.sidebar').toggleClass 'toggled'
      if $('.sidebar').hasClass('toggled')
        $('.sidebar .collapse').collapse 'hide'
      return
    # Close any open menu accordions when window is resized below 768px
    $(window).resize ->
      if $(window).width() < 768
        $('.sidebar .collapse').collapse 'hide'
      return
    # Prevent the content wrapper from scrolling when the fixed side navigation hovered over
    $('body.fixed-nav .sidebar').on 'mousewheel DOMMouseScroll wheel', (e) ->
      if $(window).width() > 768
        e0 = e.originalEvent
        delta = e0.wheelDelta or -e0.detail
        @scrollTop += (if delta < 0 then 1 else -1) * 30
        e.preventDefault()
      return
    # Scroll to top button appear
    $(document).on 'scroll', ->
      scrollDistance = $(this).scrollTop()
      if scrollDistance > 100
        $('.scroll-to-top').fadeIn()
      else
        $('.scroll-to-top').fadeOut()
      return
    # Smooth scrolling using jQuery easing
    $(document).on 'click', 'a.scroll-to-top', (e) ->
      $anchor = $(this)
      $('html, body').stop().animate { scrollTop: $($anchor.attr('href')).offset().top }, 1000, 'easeInOutExpo'
      e.preventDefault()
      return
    return
  ) jQuery

  @scrollToTop = ->
    window.scrollTo(0,0)