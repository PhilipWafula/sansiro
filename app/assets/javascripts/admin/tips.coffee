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
  $('.date-picker').datepicker
    format: 'dd/mm/yyyy'
    startDate: '-0d'

  $('.time-picker').timepicker
    defaultTime: 'current'
    showSeconds: false
    icons:
      up: 'fas fa-chevron-up'
      down: 'fas fa-chevron-down'

$ ->
  Chart.defaults.global.defaultFontFamily = 'Nunito'
  '-apple-system,system-ui,BlinkMacSystemFont,"Segoe UI",Roboto,"Helvetica Neue",Arial,sans-serif'
  Chart.defaults.global.defaultFontColor = '#858796'
  # Area Chart Example
  ctx = document.getElementById('tipsAreaChart')
  myLineChart = new Chart(ctx,
    type: 'line'
    data:
      labels: [
        'Jan'
        'Feb'
        'Mar'
        'Apr'
        'May'
        'Jun'
        'Jul'
        'Aug'
        'Sep'
        'Oct'
        'Nov'
        'Dec'
      ]
      datasets: [ {
        label: 'Tips count'
        lineTension: 0.3
        backgroundColor: 'rgba(78, 115, 223, 0.05)'
        borderColor: 'rgba(78, 115, 223, 1)'
        pointRadius: 3
        pointBackgroundColor: 'rgba(78, 115, 223, 1)'
        pointBorderColor: 'rgba(78, 115, 223, 1)'
        pointHoverRadius: 3
        pointHoverBackgroundColor: 'rgba(78, 115, 223, 1)'
        pointHoverBorderColor: 'rgba(78, 115, 223, 1)'
        pointHitRadius: 10
        pointBorderWidth: 2
        data: $('.chart-area').data('chart-information')
      } ]
    options:
      maintainAspectRatio: false
      layout: padding:
        left: 10
        right: 25
        top: 25
        bottom: 0
      scales:
        xAxes: [ {
          time: unit: 'date'
          gridLines:
            display: false
            drawBorder: false
          ticks: maxTicksLimit: 7
        } ]
        yAxes: [ {
          ticks:
            maxTicksLimit: 5
            padding: 10
            callback: (value, index, values) ->
              '' + number_format(value)
          gridLines:
            color: 'rgb(234, 236, 244)'
            zeroLineColor: 'rgb(234, 236, 244)'
            drawBorder: false
            borderDash: [ 2 ]
            zeroLineBorderDash: [ 2 ]
        } ]
      legend: display: false
      tooltips:
        backgroundColor: 'rgb(255,255,255)'
        bodyFontColor: '#858796'
        titleMarginBottom: 10
        titleFontColor: '#6e707e'
        titleFontSize: 14
        borderColor: '#dddfeb'
        borderWidth: 1
        xPadding: 15
        yPadding: 15
        displayColors: false
        intersect: false
        mode: 'index'
        caretPadding: 10
        callbacks: label: (tooltipItem, chart) ->
          datasetLabel = chart.datasets[tooltipItem.datasetIndex].label or ''
          datasetLabel + ':' + number_format(tooltipItem.yLabel) + ' tips'
  )

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


