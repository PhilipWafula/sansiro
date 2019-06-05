class CreatePendingTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :pending_transactions do |t|
      t.string :service_name
      t.numeric :business_number
      t.string :transaction_reference
      t.numeric :internal_transaction_id
      t.timestamp :transaction_timestamp
      t.string :account_number
      t.string :transaction_type
      t.numeric :sender_phone
      t.string :first_name
      t.string :middle_name
      t.string :last_name
      t.numeric :amount
      t.string :currency
      t.string :signature
      t.string :subscription_package
      t.string :child_message_status

      t.timestamps
    end
  end
end
