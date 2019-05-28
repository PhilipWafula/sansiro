# frozen_string_literal: true

require 'typhoeus'
require 'json'

module BulkSms
  class AfricasTalkingSms
    # Relays an SMS message via an SMS gateway for delivery
    # recipient - Phone number in international format +254799200300
    # message - SMS text message.
    #
    # Returns a hash array of parsed response from the gateway
    def relay_message(recipient, message)
      api_response = nil
      gateway_params = {
        username: Rails.application.secrets.sms_gateway_username,
        message: message,
        to: recipient
      }
      request = Typhoeus::Request.new(Rails.application.secrets.sms_gateway_endpoint,
                                      method: :post,
                                      headers: { Accept: 'application/json', ApiKey: Rails.application.secrets.sms_gateway_api_key },
                                      connecttimeout: 10_000,   # milliseconds
                                      timeout: 10_000,          # milliseconds
                                      body: gateway_params)
      request.on_complete do |r|
        api_response = parse_response(r)
        africas_talking_logger.info("Received response for sms request to #{recipient} - #{r.inspect}")
      end
      africas_talking_logger.info("Dispatching SMS to PRSP: #{request.inspect}")
      request.run
      api_response
    end

    # Parses the response received from the sms gateway.
    #
    # recipient - Phone number which the message is to be sent to.
    # response -  Typhoeus Response object containing the response meta data.
    #
    # Africa's Talking SMS gateway will respond with a JSON object which has the
    # receipt status of that message and the message Id
    #
    #
    # Returns a hash containing the message id and status code for
    # that relayed request.
    # {
    #   "SMSMessageData": {
    #     "Message": "Sent to 2\/2 Total Cost: KES 1.80",
    #     "Recipients": [
    #       {
    #         "number": "+254799345678",
    #         "status": "Success",
    #         "cost": "KES 0.80",
    #         "messageId": "ATSid_0bee901ca5e6cf4f8836ff89cfc8763c"
    #       },
    #       {
    #         "number": "+254799987654",
    #         "status": "Success",
    #         "cost": "KES 1.00",
    #         "messageId": "ATSid_12d27943f127f5d87e6ef4ba1b00bba3"
    #       }
    #     ]
    #   }
    # }
    # For curl return codes refer to http://curl.haxx.se/libcurl/c/libcurl-errors.html
    def parse_response(response)
      report = {}
      if response.success?
        JSON.parse(response.body)['SMSMessageData']['Recipients'].collect do |entry|
          report[:status] = entry['status'] == 'Success' ? 'successful' : 'failed'
          report[:status_code] = entry['status']
          report[:message_id] = entry['messageId']
          report[:http_status_code] = response.code
          report[:phone_number] = entry['number'].sub('+', '')
          report[:sent_at] = Time.current
        end
      end
      report
    end

    def africas_talking_logger
      @africas_talking_logger ||= if Rails.env == 'test'
                                    Logger.new(STDERR)
                                  else
                                    Logger.new("#{Rails.root}/log/africas_talking_sms.log")
                                  end
      @africas_talking_logger
    end
  end
end
