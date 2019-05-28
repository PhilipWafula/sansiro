class AddBelongsToAdminToAdminTips < ActiveRecord::Migration[5.2]
  def change
    add_reference :admin_tips, :admin, foreign_key: true
  end
end
