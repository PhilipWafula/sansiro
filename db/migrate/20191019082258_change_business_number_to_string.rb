class ChangeBusinessNumberToString < ActiveRecord::Migration[5.2]
  def change
    change_column :mpesa_transactions, :business_number, :string
    change_column :pending_transactions, :business_number, :string
    change_column :resolved_transactions, :business_number, :string
  end
end
