class CreateApiResponses < ActiveRecord::Migration[5.2]
  def change
    create_table :api_responses do |t|
      t.string :request_identifier, null: false
      t.string :type
      t.string :status, null: false
      t.string :status_description
      t.string :response_code
    end
  end
end
