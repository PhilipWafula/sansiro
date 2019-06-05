class CreateApiResponses < ActiveRecord::Migration[5.2]
  def change
    create_table :api_responses do |t|
      t.string :request_identifier, null: false
      t.string :message_type
      t.string :status, null: false
      t.string :status_description
      t.string :response_code
      t.string :recipient_phone_number
      t.datetime :message_sent_at
      t.string :parent_transaction_reference
    end
  end
end
