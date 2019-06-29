# frozen_string_literal: true

class TipsSmsWorker
  include Sidekiq::Worker
  sidekiq_options retry: false, queue: :critical

  def perform(recipient, message)
    delivery_report = BulkSms::AfricasTalkingSms.new.relay_message(recipient, message)
  end
end