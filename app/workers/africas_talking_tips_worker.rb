# frozen_string_literal: true

class AfricasTalkingTipsWorker
  include Sidekiq::Worker
  sidekiq_options retry: false, queue: :critical

  def perform(recipient, message)
    BulkSms::AfricasTalkingSms.new.relay_message(recipient, message)
  end
end