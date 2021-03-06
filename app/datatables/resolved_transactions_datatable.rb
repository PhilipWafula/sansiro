class ResolvedTransactionsDatatable < AjaxDatatablesRails::ActiveRecord

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      # id: { source: "User.id", cond: :eq },
      # name: { source: "User.name", cond: :like }
      id: { source: 'ResolvedTransaction.id' },
      full_name: { source: 'ResolvedTransaction.full_name' },
      amount: { source: 'ResolvedTransaction.amount' },
      business_number: { source: 'ResolvedTransaction.business_number' },
      subscription_package: { source: 'ResolvedTransaction.subscription_package' },
      sender_phone: { source: 'ResolvedTransaction.sender_phone' },
      transaction_timestamp: { source: 'ResolvedTransaction.transaction_timestamp' },
      child_message_status: { source: 'ResolvedTransaction.child_message_status' }
    }
  end

  def data
    records.map do |resolved_transaction|
      {
        # example:
        # id: record.id,
        # name: record.name
        id: resolved_transaction.id,
        full_name: resolved_transaction.full_name,
        amount: resolved_transaction.amount,
        business_number: resolved_transaction.business_number,
        subscription_package: resolved_transaction.subscription_package,
        sender_phone: resolved_transaction.sender_phone,
        transaction_timestamp: resolved_transaction.transaction_timestamp&.strftime('%Y-%m-%d %T'),
        child_message_status: resolved_transaction.child_message_status,
        DT_RowId: resolved_transaction.id
      }
    end
  end

  def get_raw_records
    # insert query here
    # User.all
    ResolvedTransaction.all
  end

end
