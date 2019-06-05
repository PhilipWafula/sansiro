class CreateAdminTips < ActiveRecord::Migration[5.2]
  def change
    create_table :admin_tips do |t|
      t.string :tip_content
      t.string :tip_package
      t.date :tip_date, null: false
      t.timestamps
    end
  end
end
