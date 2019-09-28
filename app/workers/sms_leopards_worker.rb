class SmsLeopardsTipsWorker
  include Sidekiq::Worker
  sidekiq_options retry: false, queue: :critical

  def perform(recipient, message)
    BulkSms::SmsLeopards.new.relay_message(recipient, message)
  end
end