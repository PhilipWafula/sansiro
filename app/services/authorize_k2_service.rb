# frozen_string_literal: true

class AuthorizeK2Service
  attr_accessor :request

  def initialize(request)
    @request = request
  end

  def authenticate_request
    request_body = Yajl::Parser.parse(request.body.string.as_json)
    request_headers = Yajl::Parser.parse(request.headers.env.select { |k, _| k =~ /^HTTP_/ }.to_json)
    x_signature = request_headers['HTTP_X_KOPOKOPOSIGNATURE']
    kopokopo_api_key = Rails.application.secrets.k2_api_key
    raise ArgumentError, 'Erroneous request, unauthorized sender' unless authenticate(request_body, kopokopo_api_key, x_signature)

    request_body
  end

  private

  def authenticate(json_body, api_key, signature)
    raise ArgumentError, "Nil Authentication Argument!\n Check whether your Input is Empty" if json_body.blank? || api_key.blank? || signature.blank?

    digest = OpenSSL::Digest.new('sha256')
    hmac = OpenSSL::HMAC.hexdigest(digest, api_key, json_body.to_json)
    raise ArgumentError, "Invalid Details Given!\n Ensure that your the Arguments Given are correct, namely:\n\t- The Response Body\n\t- Secret Key\n\t- Signature" unless ActiveSupport::SecurityUtils.secure_compare(hmac, signature)

    true
  end
end