$ ->
  pendingTransactionsTable = $('#pendingTransactionsTable').dataTable
    processing: true
    serverSide: true
    columnDefs: [ {
      'orderable': false
      'targets': -1
    } ]
    ajax:
      url: $('#pendingTransactionsTable').data('source')
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

  $('#pendingTransactionsTable').delegate 'tbody > tr', 'click', ->
    id = @id
    aData = pendingTransactionsTable.fnGetData( this )
    if id
      url = '/admin/pending_transactions/' + id
      document.location.href = url
