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
    compute_subscription_package(request['amount'].to_d, recipient, request)
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
      SmsLeopardsWorker.perform_async(recipient,
                                      'The amount sent is invalid, please send 50 for regular, 100 for premium or 80 for Jackpot',
                                      default_sender(request['business_number']))
    end
    request['subscription_package'] = subscription_package
  end

  def send_tip(recipient_phone, message, sender_account)
    SmsLeopardsWorker.perform_async(recipient_phone, message, sender_account)
  end

  def process_admin_tip(request)
    # get recipient
    message_recipient = request['sender_phone']
    # define message
    child_message = ''
    # get message
    child_message = valid_tip.take!.tip_content unless valid_tip.blank?
    # get sender
    sender_account = ''
    sender_account = valid_tip.take!.tip_sender unless valid_tip.blank?
    # send tips
    if child_message.blank? && request['child_message_status'].blank?
      request['child_message_status'] = 'Pending'
      if valid_payment?(request['amount'])
        SmsLeopardsWorker.perform_async(message_recipient,
                                        'Your payment has been received and tips will be sent shortly',
                                        default_sender(request['business_number']))
      end
      PendingTransaction.new(request).save!
    else
      request['child_message_status'] = 'Scheduled'
      if sender_account.blank?
        send_tip(message_recipient, child_message, default_sender(request['business_number']))
      else
        send_tip(message_recipient, child_message, sender_account)
      end
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

  def default_sender(business_number)
    case business_number
    when '598771'
      'OFFSIDE'
    when '810364'
      'SANSIROTECH'
    else
      'SANSIROTECH'
    end
  end

  def valid_payment?(amount)
    [50, 80, 100].include?(amount)
  end
end
