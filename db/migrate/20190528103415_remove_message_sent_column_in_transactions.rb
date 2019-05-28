class RemoveMessageSentColumnInTransactions < ActiveRecord::Migration[5.2]
  def change
    remove_column :mpesa_transactions, :message_sent
  end
end
