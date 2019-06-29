
$ ->
  marketingCampaignsTable = $('#marketingCampaignsTable').dataTable
    keys: !0
    language: paginate:
      previous: '<i class=\'mdi mdi-chevron-left\'>'
      next: '<i class=\'mdi mdi-chevron-right\'>'
    drawCallback: ->
      $('.dataTables_paginate > .pagination').addClass 'pagination-rounded'
      $('.first.paginate_button, .last.paginate_button').hide()
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

  # recipients_dropzone = $('div#hello').dropzone url: '/admin/multiple_recipients_campaign'

  Dropzone.autoDiscover = false;

  $('[data-plugin="dropzone"]').each ->
    actionUrl = '/admin/multiple_recipients_campaign'
    previewContainer = $(this).data('previewsContainer')
    opts = url: actionUrl
    if previewContainer
      opts['previewsContainer'] = previewContainer
    uploadPreviewTemplate = $(this).data('uploadPreviewTemplate')
    if uploadPreviewTemplate
      opts['previewTemplate'] = $(uploadPreviewTemplate).html()
    # uploadButton = $(this).data('uploadButton')
    # if uploadButton
    #  opts['autoQueue'] = false
    dropzoneEl = $(this).dropzone(opts)


    return
  return



$('.toast').toast 'show'
