# frozen_string_literal: true

require 'csv'
require 'smarter_csv'

class ProcessCsvWorker
  include Sidekiq::Worker
  sidekiq_options retry: false, queue: :critical

  def perform(recipients, message_body)
    # define phone numbers
    phone = FormatPhoneService.internationalize_phone(val["recipients"].to_s.strip, 'KE')

    # generate unique campaign reference
    campaign_reference = generate_token

    # iterate through hash to send messages
    recipients.each_with_index do |val, index|

      # create campaign
      marketing_campaign = MarketingCampaign.new do |campaign|
        campaign.campaign_ref = campaign_reference
        campaign.message_body = message_body
        campaign.message_recipient = phone
      end
      marketing_campaign.save!

      # send campaign and get delivery report
      delivery_report = BulkSms::AfricasTalkingSms.new.relay_message(phone, message_body)

      # save api response
      save_api_response(delivery_report, campaign_reference)
    end
  end

  private

  def save_api_response(response, campaign_ref)
    api_response = ApiResponse.new do |r|
      r.request_identifier = response[:message_id]
      r.message_type = 'SendMarketingCampaign'
      r.status = response[:status_code]
      r.status_description = response[:status]
      r.response_code = response[:http_status_code]
      r.recipient_phone_number = response[:phone_number]
      r.message_sent_at = response[:sent_at].to_datetime
      r.parent_transaction_reference = campaign_ref
    end
    api_response.save! unless api_response.blank?
  end

  def generate_token
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless MarketingCampaign.exists?(token: random_token)
    end
  end
end
