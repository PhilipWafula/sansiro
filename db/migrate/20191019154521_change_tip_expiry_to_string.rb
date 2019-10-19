class ChangeTipExpiryToString < ActiveRecord::Migration[5.2]
  def change
    change_column :tips, :tip_expiry, :string
  end
end
