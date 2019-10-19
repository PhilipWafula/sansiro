# frozen_string_literal: true

require 'typhoeus'
require 'json'

module BulkSms
  class SmsLeopards
    def relay_message(recipient, message, sender_account)
      api_response = nil
      # build message hash
      destination = [{ 'number' => recipient }]
      gateway_params = {
        source: sender_account,
        message: message,
        destination: destination,
        status_secret: sender_configs(sender_account)[:sms_leopards_status_secret]
      }

      headers = { "Content-Type": 'application/json', "Authorization": sender_configs(sender_account)[:sms_leopards_basic_auth] }

      request = Typhoeus::Request.new(Rails.application.credentials[Rails.env.to_sym][:sms_leopards_gateway_endpoint],
                                      method: :post,
                                      headers: headers,
                                      connecttimeout: 10_000, # millisecond
                                      timeout: 10_000, # millisecond
                                      body: JSON.dump(gateway_params))
      request.on_complete do |r|
        api_response = parse_response(r)
        sms_leopards_logger.info("Received response for sms request to #{recipient} - #{r.inspect}")
        # Quick 3fix Logger
        Rails.logger = Logger.new(STDOUT)
        ActiveSupport::Logger.new("log/#{Rails.env}.log")
        Rails.logger.level = Logger::DEBUG
        Rails.logger.debug "Received response form sms request to #{recipient} - #{r.inspect}"
      end
      sms_leopards_logger.info("Dispatching SMS to PRSP: #{request.inspect}")
      request.run
    end

    def basic_auth_token
      account_id = Rails.application.credentials[Rails.env.to_sym][:sms_leopards_account_id]
      api_secret = Rails.application.credentials[Rails.env.to_sym][:sms_leopards_api_secret]
      begin
        Base64.encode64("#{account_id}:#{api_secret}").strip
      rescue StandardError => e
        sms_leopards_logger.error("Failed to base64 encode basic authentication credentials: #{e}")
      end
    end

    def parse_response(response)
      report = {}
      if response.success?
        JSON.parse(response.body)['recipients'].collect do |entry|
          report[:phone_number] = entry['number']
          report[:status] = entry['status'] == 'Success' ? 'successful' : 'failed'
          report[:cost] = entry['cost']
          report[:id] = entry['id']
        end
      end
      report
    end

    def sender_configs(sender)
      configs = {}
      case sender
      when 'EUROPA_TECH'
        configs.merge(sms_leopards_basic_auth: Rails.application.credentials[Rails.env.to_sym][:sms_leopards_europa_tech_basic_auth],
                      sms_leopards_status_secret: Rails.application.credentials[Rails.env.to_sym][:sms_leopards_europa_tech_status_secret])
      when 'OFFSIDE'
        configs.merge(sms_leopards_basic_auth: Rails.application.credentials[Rails.env.to_sym][:sms_leopards_offside_basic_auth],
                      sms_leopards_status_secret: Rails.application.credentials[Rails.env.to_sym][:sms_leopards_offside_status_secret])
      when 'SANSIROTECH'
        configs.merge(sms_leopards_basic_auth: Rails.application.credentials[Rails.env.to_sym][:sms_leopards_sansiro_basic_auth],
                      sms_leopards_status_secret: Rails.application.credentials[Rails.env.to_sym][:sms_leopards_sansiro_status_secret])
      else
        sms_leopards_logger.error('Cannot commute sender configs.')
      end
    end

    def sms_leopards_logger
      @sms_leopards_logger ||= if Rails.env == 'test'
                                 # Quick fix  Logger
                                 Rails.logger = Logger.new(STDOUT)
                                 ActiveSupport::Logger.new("log/#{Rails.env}.log")
                                 Rails.logger.level = Logger::DEBUG
                                 Rails.logger.debug "Received response for sms request to #{recipient} - #{r.inspect}"
                               else
                                 Logger.new("#{Rails.root}/log/sms_leopards_sms.log")
                               end
      @sms_leopards_logger
    end
  end
end
