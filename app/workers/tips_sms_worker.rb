# frozen_string_literal: true

class TipsSmsWorker
  include Sidekiq::Worker
  sidekiq_options retry: false, queue: :critical

  def perform(recipient, message, transaction_ref)
    delivery_report = BulkSms::AfricasTalkingSms.new.relay_message(recipient, message)
    save_api_response(delivery_report, transaction_ref) unless delivery_report.blank?
  end

  private

  def save_api_response(response, transaction_ref)
    api_response = ApiResponse.new do |r|
      r.request_identifier = response[:message_id]
      r.message_type = 'SendBettingTip'
      r.status = response[:status_code]
      r.status_description = response[:status]
      r.response_code = response[:http_status_code]
      r.recipient_phone_number = response[:phone_number]
      r.message_sent_at = response[:sent_at].to_datetime
      r.parent_transaction_reference = transaction_ref
    end
    api_response.save! unless api_response.blank?
  end

end