class CreateTips < ActiveRecord::Migration[5.2]
  def change
    create_table :tips do |t|
      t.string :tip_content
      t.string :tip_package
      t.timestamp :tip_expiry
      t.date :tip_date, null: false
      t.belongs_to :admin, foreign_key: true
      t.timestamps
    end
  end
end
