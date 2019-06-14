# frozen_string_literal: true

class ProcessTransactionService
  attr_accessor :request

  def initialize(request)
    @request = request
  end

  def process_request
    subscription_package = compute_subscription_package(request['amount'].to_f)
    request['subscription_package'] = subscription_package
    process_admin_tip(request)
  end

  private

  def compute_subscription_package(amount)
    case amount
    when 50
      subscription_package = 'Regular'
    when 100
      subscription_package = 'Premium'
    when 80
      subscription_package = 'Jackpot'
    else
      raise 'Invalid amount, no respective package'
    end
    subscription_package
  end

  def send_tip(recipient_phone, message, transaction_ref)
    TipsSmsWorker.perform_async(recipient_phone, message, transaction_ref)
  end

  def process_admin_tip(request)
    # get transaction date
    transaction_date = request['transaction_timestamp'].to_date
    # get subscription package
    subscription_package = request['subscription_package']
    # get transaction reference
    transaction_reference = request['transaction_reference']
    # get message recipient
    message_recipient = request['sender_phone']
    # get message
    child_message = ''
    # get tip is present
    child_message = Admin::Tip.where(tip_date: transaction_date, tip_package: subscription_package).take!.tip_content unless Admin::Tip.where(tip_date: transaction_date, tip_package: subscription_package).blank?
    if child_message.blank? && request['child_message_status'].blank? && request['child_message_status'] != 'Pending'
      request['child_message_status'] = 'Pending'
      PendingTransaction.new(request).save!
      process_transaction_logger.info 'Pending transaction logged.'
    else
      request['child_message_status'] = 'Scheduled'
      send_tip(message_recipient, child_message, transaction_reference)
      MpesaTransaction.new(request).save!
    end
  end

  def process_transaction_logger
    @process_transaction_logger ||= Logger.new("#{Rails.root}/log/services/process_transaction_logger.log")
  end
end
