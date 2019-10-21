$ ->
  mpesaTransactionsTable = $('#mpesaTransactionsTable').dataTable
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
      'orderable': false
      'targets': -1
    } ]
    ajax:
      url: $('#mpesaTransactionsTable').data('source')
    pagingType: 'full_numbers'
    columns: [
      {data: 'id'}
      {data: 'full_name'}
      {data: 'amount'}
      {data: 'business_number'}
      {data: 'subscription_package'}
      {data: 'sender_phone'}
      {data: 'transaction_timestamp'}
      {data: 'child_message_status'}
    ]

  $('#mpesaTransactionsTable').delegate 'tbody > tr', 'click', ->
    id = @id
    aData = mpesaTransactionsTable.fnGetData( this )
    if id
      url = '/admin/mpesa_transactions/' + id
      document.location.href = url
