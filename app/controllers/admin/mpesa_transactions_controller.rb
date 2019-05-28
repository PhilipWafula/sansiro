# frozen_string_literal: true

require 'yajl'

class Admin::MpesaTransactionsController < ApplicationController
  protect_from_forgery with: :null_session
  layout 'admin/application'

  # GET /mpesa_transactions
  def index
    @transactions = MpesaTransaction.all
    render json: @transactions
  end

  # GET /mpesa_transactions/:id
  def show
    render json: @transaction
  end

  # POST /mpesa_transactions
  def new
    @transaction = MpesaTransaction.new
  end

  # POST /mpesa_transactions
  def create
    @transaction = MpesaTransaction.new(transaction_params)

    if @transaction.save
      render json: @transaction, status: :created, location: @transaction
    else
      render json: @transaction.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /mpesa_transactions/1
  def update
    if @transaction.update(transaction_params)
      render json: @transaction
    else
      render json: @transaction.errors, status: :unprocessable_entity
    end
  end

  # DELETE /transaction/1
  def destroy
    @transaction.destroy
  end

  def receive
    if request.blank?
      render json: { message: 'Bad Request' }, status: :bad_request
    else
      # ProcessTransactionService.new(request).process_request
      render json: { message: 'ok' }, status: :ok
    end
  end

  private

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
                                              :package)
  end
end
