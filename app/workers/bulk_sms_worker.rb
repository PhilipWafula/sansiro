# frozen_string_literal: true

# send sms worker
class BulkSmsWorker
  include Sidekiq::Worker
  sidekiq_options retry: false, queue: :critical

  def perform(recipient, message)
    BulkSms::AfricasTalkingSms.new.relay_message(recipient, message)
  end

  def persist_api_response(response)
    api_response = ApiResponse.create do |r|

    end

    api_response.save!
  end
end