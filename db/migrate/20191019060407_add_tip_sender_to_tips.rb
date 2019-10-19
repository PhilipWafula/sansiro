class AddTipSenderToTips < ActiveRecord::Migration[5.2]
  def change
    add_column :tips, :tip_sender, :string
  end
end
