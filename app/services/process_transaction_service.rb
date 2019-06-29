# frozen_string_literal: true

class ProcessTransactionService
  attr_accessor :request

  def initialize(request)
    @request = request
  end

  def process_request
    # get recipient
    recipient = request['sender_phone']
    # add subscription package
    compute_subscription_package(request['amount'].to_f, recipient, request)
    # process tip
    process_admin_tip(request)
  end

  private

  def compute_subscription_package(amount, recipient, request)
    case amount
    when 50
      subscription_package = 'Regular'
    when 100
      subscription_package = 'Premium'
    when 80
      subscription_package = 'Jackpot'
    else
      subscription_package = 'Irregular'
      BulkSmsWorker.perform_async(recipient, 'The amount sent is invalid, please send 50 for regular, 100 for premium or 80 for Jackpot')
      process_transaction_logger.info 'Invalid amount paid'
    end
    request['subscription_package'] = subscription_package
  end

  def send_tip(recipient_phone, message)
    TipsSmsWorker.perform_async(recipient_phone, message)
  end

  def process_admin_tip(request)
    # get recipient
    message_recipient = request['sender_phone']
    # define message
    child_message = ''
    # get message
    child_message = valid_tip.take!.tip_content unless valid_tip.blank?
    # send tips
    if child_message.blank? && request['child_message_status'].blank?
      request['child_message_status'] = 'Pending'
      BulkSmsWorker.perform_async(message_recipient, 'Your payment has been received and tips will be sent shortly')
      PendingTransaction.new(request).save!
      process_transaction_logger.info 'Pending transaction logged.'
    else
      request['child_message_status'] = 'Scheduled'
      send_tip(message_recipient, child_message)
      MpesaTransaction.new(request).save!
    end
  end

  def valid_tip
    # get subscription package
    subscription_package = request['subscription_package']
    # get transaction date
    transaction_date = request['transaction_timestamp'].to_date
    # get message recipient
    current_time = Time.now
    # get tip
    Tip.where('tip_expiry > ? AND tip_package = ? AND tip_date = ?', current_time, subscription_package, transaction_date)
  end

  def process_transaction_logger
    @process_transaction_logger ||= if Rails.env == 'test'
                                      Logger.new(STDERR)
                                    else
                                      Logger.new("#{Rails.root}/log/services/process_transaction_logger.log")
                                    end
  end
end
