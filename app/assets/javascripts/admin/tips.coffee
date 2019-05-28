# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery(document).ready ->
  tipsTable = $('#tipsTable').dataTable
    processing: true
    serverSide: true
    columnDefs: [ {
      'orderable': false
      'targets': -1
    } ]
    ajax:
      url: $('#tipsTable').data('source')
    pagingType: 'full_numbers'
    columns: [
      {data: 'id'}
      {data: 'tip_content'}
      {data: 'tip_package'}
      {data: 'tip_date'}
    ]

  $('#tipsTable').delegate 'tbody > tr', 'click', ->
    id = @id
    aData = tipsTable.fnGetData( this )
    if id
      url = '/admin/tips/' + id
      document.location.href = url

  $('#datetimepicker4').datetimepicker
    format: 'MMMM D, YYYY'
    minDate: Date()
    maxDate: new Date(Date.now() + 365 * 24 * 60 * 60 * 1000)
    icons:
      up: 'fas fa-arrow-up'
      down: 'fas fa-arrow-down'
      previous: 'fas fa-chevron-left'
      next: 'fas fa-chevron-right'
      close: 'fas fa-times'
    buttons: showClose: true

  @scrollToTop = ->
    window.scrollTo(0,0)

  return

