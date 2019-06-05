$ ->
  mpesaTransactionsTable = $('#mpesaTransactionsTable').dataTable
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
      {data: 'first_name'}
      {data: 'last_name'}
      {data: 'amount'}
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
