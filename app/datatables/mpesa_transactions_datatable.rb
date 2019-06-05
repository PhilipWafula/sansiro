# frozen_string_literal: true

class MpesaTransactionsDatatable < AjaxDatatablesRails::ActiveRecord
  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      # id: { source: "User.id", cond: :eq },
      # name: { source: "User.name", cond: :like }
      id: { source: 'MpesaTransaction.id' },
      first_name: { source: 'MpesaTransaction.first_name' },
      last_name: { source: 'MpesaTransaction.last_name' },
      amount: { source: 'MpesaTransaction.amount' },
      subscription_package: { source: 'MpesaTransaction.subscription_package' },
      sender_phone: { source: 'MpesaTransaction.sender_phone' },
      transaction_timestamp: { source: 'MpesaTransaction.transaction_timestamp' },
      child_message_status: { source: 'MpesaTransaction.child_message_status' }
    }
  end

  def data
    records.map do |pt|
      {
        # example:
        # id: pt.id,
        # name: pt.name
        id: pt.id,
        first_name: pt.first_name,
        last_name: pt.last_name,
        amount: pt.amount,
        subscription_package: pt.subscription_package,
        sender_phone: pt.sender_phone,
        transaction_timestamp: pt.transaction_timestamp,
        child_message_status: pt.child_message_status,
        DT_RowId: pt.id
      }
    end
  end

  def get_raw_records
    # insert query here
    # User.all
    MpesaTransaction.all
  end
end
