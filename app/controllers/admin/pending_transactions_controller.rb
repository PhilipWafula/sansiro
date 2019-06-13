require 'json'

class Admin::PendingTransactionsController < ApplicationController
  before_action :authenticate_admin!
  layout 'admin/application'
  def index
    respond_to do |format|
      format.html
      format.json do
        render json: PendingTransactionDatatable.new(params)
      end
    end
    @admin_pending_transactions = PendingTransaction.all
  end

  def show
    @admin_pending_transaction = PendingTransaction.find(params[:id])
  end

  def retry_transaction
    # get transaction
    pending_transaction = PendingTransaction.find(request['id']).to_json

    # convert transaction to hash
    retry_transaction = JSON.parse(pending_transaction)

    # remove id from hash
    # process retry transaction
    ProcessTransactionService.new(retry_transaction.except('id')).process_request
  end
end
