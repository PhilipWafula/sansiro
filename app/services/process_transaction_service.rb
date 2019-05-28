# frozen_string_literal: true

class ProcessTransactionService
  attr_accessor :request

  def initialize(request)
    @request = request
  end

  def process_request
    # request components
    request_body = Yajl::Parser.parse(request.body.string.as_json)
    request_headers = Yajl::Parser.parse(request.headers.env.select { |k, _| k =~ /^HTTP_/ }.to_json)
    x_signature = request_headers['HTTP_X_KOPOKOPOSIGNATURE']
    kopokopo_api_key = Rails.application.secrets.k2_api_key

    if authenticate(request_body, kopokopo_api_key, x_signature)
      transaction_package = compute_package(request_body['amount'])
      request_body[:transaction_package] = transaction_package
    end
    process_admin_tip(request_body)
  end

  def compute_package(amount)
    # check package to append package value
    case amount
    when 50
      transaction_package = 'Regular'
    when 150
      transaction_package = 'Premium'
    when 300
      transaction_package = 'Jackpot'
    else
      raise 'Invalid amount, no respective package'
    end
    transaction_package
  end

  def send_tip(recipient_phone, message)
    BulkSmsWorker.perform_async(recipient_phone, message)
  end

  def process_admin_tip(transaction)
    # check transaction date
    transaction_date = transaction['transaction_timestamp'].to_date
    transaction_package = transaction['transaction_package']

    # check if message for package matches date
    message = Admin::Tip.where(tip_package: transaction_package, tip_date: transaction_date.to_s)
    if message.nil?
      # queue job for waiting on db
    else
      recipient = transaction['sender_phone']
      send_tip(recipient, message)
    end
  end

  private

  def authenticate(json_body, api_key, signature)
    raise ArgumentError, "Nil Authentication Argument!\n Check whether your Input is Empty" if json_body.blank? || api_key.blank? || signature.blank?

    digest = OpenSSL::Digest.new('sha256')
    hmac = OpenSSL::HMAC.hexdigest(digest, api_key, json_body.to_json)
    raise ArgumentError, "Invalid Details Given!\n Ensure that your the Arguments Given are correct, namely:\n\t- The Response Body\n\t- Secret Key\n\t- Signature" unless ActiveSupport::SecurityUtils.secure_compare(hmac, signature)

    true
  end

  # def process_transaction_logger
  #  process_transaction_logger ||= Logger.new("#{Rails.root}/log/services/process_transaction_logger.log")
  # end
end
