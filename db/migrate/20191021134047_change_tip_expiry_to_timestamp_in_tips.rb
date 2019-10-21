# frozen_string_literal: true

class ChangeTipExpiryToTimestampInTips < ActiveRecord::Migration[5.2]
  def change
    remove_column :tips, :tip_expiry, :string
    add_column :tips, :tip_expiry, :timestamp
  end
end
