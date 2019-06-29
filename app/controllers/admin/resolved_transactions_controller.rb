# frozen_string_literal: true

class Admin::ResolvedTransactionsController < ApplicationController
  layout 'admin/application'
  before_action :authenticate_admin!

  def index
    respond_to do |format|
      format.html
      format.json do
        render json: ResolvedTransactionsDatatable.new(params)
      end
    end
  end

  private

  def resolved_transaction_params
    params.require(:resolved_transaction).permit(:service_name,
                                                 :business_number,
                                                 :transaction_reference,
                                                 :internal_transaction_id,
                                                 :transaction_timestamp,
                                                 :transaction_type,
                                                 :account_number,
                                                 :sender_phone,
                                                 :first_name,
                                                 :middle_name,
                                                 :last_name,
                                                 :amount,
                                                 :currency,
                                                 :signature,
                                                 :message_sent,
                                                 :package,
                                                 :child_message_status)
  end
end
