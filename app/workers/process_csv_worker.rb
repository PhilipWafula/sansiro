# frozen_string_literal: true

require 'csv'
require 'smarter_csv'

class ProcessCsvWorker
  include Sidekiq::Worker
  sidekiq_options retry: false, queue: :critical

  def perform(recipients, message_body)
    # iterate through hash to send messages
    recipients.each_with_index do |val, index|
      # define phone numbers
      phone = FormatPhoneService.internationalize_phone(val["recipients"].to_s.strip, 'KE')

      # create campaign
      marketing_campaign = MarketingCampaign.new do |campaign|
        campaign.message_body = message_body
        campaign.message_recipient = phone
      end
      marketing_campaign.save!

      # send campaign and get delivery report
      delivery_report = BulkSms::AfricasTalkingSms.new.relay_message(phone, message_body)

      puts delivery_report
    end
  end
end
