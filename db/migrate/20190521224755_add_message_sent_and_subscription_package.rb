class AddMessageSentAndSubscriptionPackage < ActiveRecord::Migration[5.2]
  def change
    add_column :mpesa_transactions, :message_sent, :boolean, null: true
    add_column :mpesa_transactions, :subscription_package, :string
  end
end
