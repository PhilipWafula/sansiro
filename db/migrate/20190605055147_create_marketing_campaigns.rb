class CreateMarketingCampaigns < ActiveRecord::Migration[5.2]
  def change
    create_table :marketing_campaigns do |t|
      t.string :message_body
      t.string :message_recipient
      t.timestamps
    end
  end
end
