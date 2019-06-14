# frozen_string_literal: true

require 'yajl'
require 'base64'
require 'openssl'

class Admin::MpesaTransactionsController < ApplicationController
  protect_from_forgery with: :null_session, only: :receive
  before_action :authenticate_admin!, except: :receive
  layout 'admin/application'

  # GET /mpesa_transactions
  def index
    respond_to do |format|
      format.html
      format.json do
        render json: MpesaTransactionsDatatable.new(params)
      end
    end
    @admin_mpesa_transactions = MpesaTransaction.all
  end

  # GET /mpesa_transactions/:id
  def show
    set_admin_mpesa_transaction
  end

  def receive
    if request.blank?
      render json: { message: 'Bad Request' }, status: :bad_request
    else
      # REVISIT THIS TO VALIDATE K2 REQUESTS
      # Get request body
      request_body = Yajl::Parser.parse(request.body.string.as_json)
      ProcessTransactionService.new(request_body).process_request

      render json: { message: 'ok' }, status: :ok
    end
  end

  private

  def set_admin_mpesa_transaction
    @admin_mpesa_transaction = MpesaTransaction.find(params[:id])
  end

  def transaction_params
    params.require(:mpesa_transaction).permit(:service_name,
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
