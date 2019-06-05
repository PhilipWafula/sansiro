$ ->
  marketingCampaignsTable = $('#marketingCampaignsTable').dataTable
    processing: true
    serverSide: true
    columnDefs: [{
      'orderable': true
      'targets': -1
    }]
    ajax:
      url: $('marketingCampaignsTable').data('source')
    pagingType: 'full_numbers'
    columns: [
      {data: 'id'}
      {data: 'message_body'}
      {data: 'message_recipient'}
    ]

  $('marketingCampaignsTable').delegate 'tbody > tr', 'click', ->
    id = @id
    aData = marketingCampaignsTable.fnGetData(this)
    if id
      url = '/admin/marketing_campaigns/' + id
      document.location.href = url


$('.toast').toast 'show'