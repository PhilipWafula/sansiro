class RemoveTipRecipientIn < ActiveRecord::Migration[5.2]
  def up
    remove_column :admin_tips, :tip_recipient_phone
  end

  def down
    add_column :admin_tips, :tip_recipient_phone, :string, null: false
  end
end
