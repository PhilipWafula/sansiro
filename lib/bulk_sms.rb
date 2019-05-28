module BulkSms
  extend self

  # Wrapper for sending SMS messages to a recipient through a configured SMS gateway synchronously
  # recipient - A String representing a phone number in international format +2547XXXXXXXX
  # message - A string with the content of the SMS. A typical SMS is 160 chars.
  # Returns a delivery report from the gateway
  def send_message!(recipient, message)
    delivery_report = BulkSms::AfricasTalkingSms.new.relay_message(recipient, message)
  end

  # Wrapper for sending SMS messages to a recipient through a configured SMS gateway asynchronously
  # recipient - A String representing a phone number in international format +2547XXXXXXXX
  # message - A string with the content of the SMS. A typical SMS is 160 chars.
  def send_message(recipient, message)
    BulkSmsWorker.perform_async(recipient, message)
  end
end
