class ChangeSenderPhoneToString < ActiveRecord::Migration[5.2]
  def change
    change_column :mpesa_transactions, :sender_phone, :string
    change_column :pending_transactions, :sender_phone, :string
    change_column :resolved_transactions, :sender_phone, :string
  end
end
