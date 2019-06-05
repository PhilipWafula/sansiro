# frozen_string_literal: true

class ProcessTransactionService
  attr_accessor :request

  def initialize(request)
    @request = request
  end

  def process_request
    subscription_package = compute_subscription_package(request['amount'])
    request['subscription_package'] = subscription_package
    process_admin_tip(request)
  end

  private

  def compute_subscription_package(amount)
    case amount
    when 50
      subscription_package = 'Regular'
    when 150
      subscription_package = 'Premium'
    when 300
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
    transaction_date = request['transaction_timestamp'].to_date
    subscription_package = request['subscription_package']
    transaction_reference = request['transaction_reference']
    child_message = Admin::Tip.where(tip_date: transaction_date, tip_package: subscription_package)
    if child_message.blank?
      request['child_message_status'] = 'Pending'
      PendingTransaction.new(request).save!
    else
      message_recipient = request['sender_phone']
      request['child_message_status'] = 'Scheduled'
      send_tip(message_recipient, child_message, transaction_reference)
    end
  end

  def process_transaction_logger
    @process_transaction_logger ||= Logger.new("#{Rails.root}/log/services/process_transaction_logger.log")
  end
end
