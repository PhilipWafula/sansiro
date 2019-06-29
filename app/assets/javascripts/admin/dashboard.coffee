$('.toast').toast 'show'

# Reset the theme
resetTheme = ->
  $('body').attr 'data-layout-mode', 'fluid'
  $('#side-main-logo').attr 'src:', 'url(\'admin/icon.png\')'
  $('#side-sm-main-logo').attr 'src', 'url(\'admin/icon_sm.png\')'
  return

# Resets the scroll
resetSidebarScroll = ->
  $('.slimscroll-menu').slimscroll
    height: 'auto'
    position: 'right'
    size: '8px'
    color: '#9ea5ab'
    wheelStep: 5
    touchScrollStep: 20
  return

# Activates the scrollable sidenar
activateScrollableSidebar = ->
  $('body').attr 'data-leftbar-compact-mode', 'scrollable'
  leftMenuContainer = $('#left-side-menu-container')
  leftMenuContainer.slimScroll destroy: true
  leftMenuContainer.removeClass 'slimscroll-menu'
  leftMenuContainer.removeAttr 'style'
  resetSidebarScroll()
  return

# Deactivates the scrollbar
deactivateScrollableSidebar = ->
  $('body').removeAttr 'data-leftbar-compact-mode'
  $('#left-side-menu-container').addClass 'slimscroll-menu'
  resetSidebarScroll()
  return

# Adjust layout based on screen size
adjustLayout = ->
  if $(window).width() >= 768 and $(window).width() <= 1028
    $('body').attr 'data-leftbar-compact-mode', 'condensed'
  if $(window).width() > 1028
    $('body').removeAttr 'data-leftbar-compact-mode'
  return


# Initalize layout
initializeLayout = ->
  $(window).on 'resize', (e) ->
    e.preventDefault()
    adjustLayout()
    resetSidebarScroll()
    return
  return

# Activates the condensed side bar
activateCondensedSidebar = ->
  $('body').attr 'data-leftbar-compact-mode', 'condensed'
  return

# Deactivates the condensed side bar
deactivateCondensedSidebar = ->
  $('body').removeAttr 'data-leftbar-compact-mode'
  return

# Initilizes the menu
initMenu = ->
# resets everything
  resetTheme()

  # sidebar - main menu
  $('.side-nav').metisMenu()

  # remove slim scroll if scrollable sidebar
  if $('body').hasClass('scrollable-layout')
    $('#left-side-menu-container').removeClass 'slimscroll-menu'

  # sidebar - scroll container
  resetSidebarScroll()

  # click events
  # Left menu collapse
  $(document).on 'click', '.button-menu-mobile', (e) ->
    e.preventDefault()
    $('body').toggleClass 'sidebar-enable'
    #sidebar - scroll container
    resetSidebarScroll()
    return

  # activate the menu in left side bar based on url
  $('.side-nav a').each ->
    pageUrl = window.location.href.split(/[?#]/)[0]
    if @href == pageUrl
# add active to li of the current link
      $(this).addClass 'active'
      $(this).parent().addClass 'mm-active'
      # add active class to an anchor
      $(this).parent().parent().addClass 'mm-show'
      $(this).parent().parent().prev().addClass 'active'
      # add active to li of the current link
      $(this).parent().parent().parent().addClass 'mm-active'
      $(this).parent().parent().parent().parent().addClass 'mm-show'
      # add active to li of the current link
      $(this).parent().parent().parent().parent().parent().addClass 'mm-active'
      $(this).parent().parent().parent().parent().parent().parent().addClass 'mm-show'
      $(this).parent().parent().parent().parent().parent().parent().parent().addClass 'mm-active'
    return

  #initializing Slimscroll
  $.fn.slimScroll and $('.slimscroll').slimScroll(
    height: 'auto'
    position: 'right'
    size: '5px'
    touchScrollStep: 20
    color: '#9ea5ab')
  return

$ ->

# adjust layout based on width
  adjustLayout()

  # initialize layout
  initializeLayout()

  # activate fluid
  $('body').attr 'data-layout-mode', 'fluid'

  # initialize menu
  initMenu()
  return

# Toggle menu button to show nav panel
$ ->
  $(document).on 'click', 'body', (e) ->
    if $(e.target).closest('.left-side-menu, .side-nav').length > 0 or $(e.target).hasClass('button-menu-mobile') or $(e.target).closest('.button-menu-mobile').length > 0
      return
    $('body').removeClass 'sidebar-enable'
    return