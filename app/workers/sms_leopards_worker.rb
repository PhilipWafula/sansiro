class SmsLeopardsWorker
  include Sidekiq::Worker
  sidekiq_options retry: false, queue: :critical

  def perform(recipient, message, sender_account)
    BulkSms::SmsLeopards.new.relay_message(recipient, message, sender_account)
  end
end