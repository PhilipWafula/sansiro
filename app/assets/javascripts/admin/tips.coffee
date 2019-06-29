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
