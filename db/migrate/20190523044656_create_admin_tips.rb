class CreateAdminTips < ActiveRecord::Migration[5.2]
  def change
    create_table :admin_tips do |t|
      t.string :tip_content
      t.string :tip_package
      t.string :tip_recipient_phone, null: false
      t.date :tip_date
      t.timestamps
    end
  end
end
