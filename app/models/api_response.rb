# frozen_string_literal: true

class ApiResponse < ApplicationRecord
  # after_create_commit :create_association

  # private

  # def create_association
  # get last api response
  # @api_response = ApiResponse.last

  # get date and recipient status
  # api_response_date = @api_response.message_sent_at.to_date
  # api_response_recipient = @api_response.recipient_phone_number
  # api_response_status = @api_response.status
  # @parent_transaction = MpesaTransaction.where(created_at: api_response_date.midnight..api_response_date.end_of_day, recipient_phone_number: api_response_recipient)
  # check transactions database for matching date and recipient
  # unless @parent_transaction.blank?
  #  result_count = @parent_transaction.transaction_reference.count
  #  if result_count > 1 && api_response_status == 'Successful'

  #  end
  # end
  # end
end
