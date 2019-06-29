$ ->
  tipsTable = $('#tipsTable').dataTable
    keys: !0
    language: paginate:
      previous: '<i class=\'mdi mdi-chevron-left\'>'
      next: '<i class=\'mdi mdi-chevron-right\'>'
    drawCallback: ->
      $('.dataTables_paginate > .pagination').addClass 'pagination-rounded'
      $('.first.paginate_button, .last.paginate_button').hide()
    processing: true
    serverSide: true
    columnDefs: [ {
      orderable: false
      targets: -1
    } ]
    ajax:
      url: $('#tipsTable').data('source')
    pagingType: 'full_numbers'
    columns: [
      {data: 'id'}
      {data: 'tip_content'}
      {data: 'tip_package'}
      {data: 'tip_expiry'}
      {data: 'tip_date'}
    ]
  $('#tipsTable').delegate 'tbody > tr', 'click', ->
    id = @id
    aData = tipsTable.fnGetData( this )
    if id
      url = '/admin/tips/' + id
      document.location.href = url
      return

number_format = (number, decimals, dec_point, thousands_sep) ->
  number = (number + '').replace(',', '').replace(' ', '')
  n = if !isFinite(+number) then 0 else +number
  prec = if !isFinite(+decimals) then 0 else Math.abs(decimals)
  sep = if typeof thousands_sep == 'undefined' then ',' else thousands_sep
  dec = if typeof dec_point == 'undefined' then '.' else dec_point
  s = ''

  toFixedFix = (n, prec) ->
    k = 10 ** prec
    '' + Math.round(n * k) / k

  # Fix for IE parseFloat(0.55).toFixed(0) = 0;
  s = (if prec then toFixedFix(n, prec) else '' + Math.round(n)).split('.')
  if s[0].length > 3
    s[0] = s[0].replace(/\B(?=(?:\d{3})+(?!\d))/g, sep)
  if (s[1] or '').length < prec
    s[1] = s[1] or ''
    s[1] += new Array(prec - (s[1].length) + 1).join('0')
  s.join dec

$ ->
# date pickers
  $('.custom-date-picker').datepicker
    format: 'dd/mm/yyyy'
    startDate: '-0d'

  $('.custom-time-picker').timepicker
    defaultTime: 'current'
    showSeconds: false
    icons:
      up: 'fas fa-chevron-up'
      down: 'fas fa-chevron-down'
