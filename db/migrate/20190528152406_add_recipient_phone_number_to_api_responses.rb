class AddRecipientPhoneNumberToApiResponses < ActiveRecord::Migration[5.2]
  def change
    add_column :api_responses, :recipient_phone_number, :string
  end
end
