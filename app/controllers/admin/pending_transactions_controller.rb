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
  end
end
