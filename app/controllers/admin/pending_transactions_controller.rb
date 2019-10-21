# frozen_string_literal: true

require 'json'

class Admin::PendingTransactionsController < ApplicationController
  before_action :authenticate_admin!
  layout 'admin/application'
  def index
    respond_to do |format|
      format.html
      format.json do
        render json: PendingTransactionsDatatable.new(params)
      end
    end
    @admin_pending_transactions = PendingTransaction.all
  end

  def show
    @admin_pending_transaction = PendingTransaction.find(params[:id])
  end

  # god mode action to move all pending transactions from yesterday to resolved transactions
  def retry_transaction
    # get transaction
    PendingTransaction.find_each(batch_size: 1000) do |pending_transaction|
      transaction = { service_name: pending_transaction.service_name,
                      business_number: pending_transaction.business_number,
                      transaction_reference: pending_transaction.transaction_reference,
                      internal_transaction_id: pending_transaction.internal_transaction_id.to_i,
                      transaction_timestamp: pending_transaction.transaction_timestamp,
                      account_number: pending_transaction.account_number,
                      transaction_type: pending_transaction.transaction_type,
                      sender_phone: pending_transaction.sender_phone,
                      first_name: pending_transaction.first_name,
                      middle_name: pending_transaction.middle_name,
                      last_name: pending_transaction.last_name,
                      amount: pending_transaction.amount.to_f,
                      currency: pending_transaction.currency,
                      signature: pending_transaction.signature,
                      subscription_package: pending_transaction.subscription_package,
                      child_message_status: pending_transaction.child_message_status }.to_json

      if pending_transaction.transaction_timestamp.to_date == Date.today
        if valid_tip(pending_transaction).present?
          # process transaction
          ProcessTransactionService.new(JSON.parse(transaction)).process_request
          # create resolved transactions
          resolved_transaction = ResolvedTransaction.new(JSON.parse(transaction))
          if resolved_transaction.save!
            # delete pending transaction
            pending_transaction.destroy!
            redirect_to admin_resolved_transactions_path
          else
            flash[:error] = "Could not resolve transaction. #{resolved_transaction.errors.full_messages.join('. ')}."
          end
        else
          flash[:error] = 'No Valid tips available'
        end
      else
        flash[:error] = 'No transaction'
      end
    end
  end

  private

  def valid_tip(pending_transaction)
    # get subscription package
    subscription_package = pending_transaction.subscription_package
    # get transaction date
    transaction_date = pending_transaction.transaction_timestamp.to_date
    # get message recipient
    current_time = Time.now
    # get tip
    Tip.where('tip_expiry > ? AND tip_package = ? AND tip_date = ?', current_time, subscription_package, transaction_date)
  end
end
