class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :mpesa_transactions do |t|
      t.string :service_name
      t.numeric :business_number
      t.string :transaction_reference
      t.numeric :k2_transaction_id
      t.timestamp :transaction_timestamp
      t.string :transaction_type
      t.numeric :transaction_sender_phone
      t.string :first_name
      t.string :middle_name
      t.string :last_name
      t.numeric :transaction_amount
      t.string :transaction_currency
      t.string :transaction_signature

      t.timestamps
    end
  end
end
