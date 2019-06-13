# frozen_string_literal: true

class FormatPhoneService
  # Returns the E.164 International format of a phone number
  # The phony-rails gem is used.
  # @param - sign - optional flag to exclude the '+' sign at the beginning
  def self.internationalize_phone(phone_number, country_code, sign = true)
    country = country_code.upcase
    number = phone_number.phony_formatted(:normalize => country, :format => :international, :spaces => '')
    if sign
      number
    else
      number = number.gsub!('+','')
    end
  end
end
