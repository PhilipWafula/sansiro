class AddNullFalseToTipDateColumnInAdminTips < ActiveRecord::Migration[5.2]
  def up
    change_column :admin_tips, :tip_date, :date, null: false
  end

  def down
    change_column :admin_tips, :tip_date, :date
  end
end
