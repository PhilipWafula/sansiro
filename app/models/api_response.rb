# frozen_string_literal: true

class ApiResponse < ApplicationRecord
  after_create_commit :update_transaction_status

  private

  def update_transaction_status
    # check for tip API response
    tip_response = ApiResponse.find_by(message_type: 'SendBettingTip')
    unless tip_response.blank?
      parent_transaction = MpesaTransaction.find_by(transaction_reference: tip_response.parent_transaction_reference)
      parent_transaction_status = parent_transaction.status_description
      parent_transaction.child_message_status = parent_transaction_status
      parent_transaction.update!
    end
    # check for marketing campaign API response
    marketing_response = ApiResponse.find_by(message_type: 'SendMarketingCampaign')
    unless marketing_response.blank?
      parent_transaction = MarketingCampaign.find_by(campaign_ref: marketing_response.parent_transaction_reference)
      parent_transaction_status = parent_transaction.status_description
      parent_transaction.child_message_status = parent_transaction_status
      parent_transaction.update!
    end
  end
end
