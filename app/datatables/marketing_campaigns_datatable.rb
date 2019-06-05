# frozen_string_literal: true

class MarketingCampaignsDatatable < AjaxDatatablesRails::ActiveRecord
  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      # id: { source: "User.id", cond: :eq },
      # name: { source: "User.name", cond: :like }
      id: { source: 'MarketingCampaign.id' },
      message_body: { source: 'MarketingCampaign.message_body' },
      message_recipient: { source: 'MarketingCampaign.message_recipient' }
    }
  end

  def data
    records.map do |message|
      {
        # example:
        # id: record.id,
        # name: record.name
        id: message.id,
        message_body: message.message_body,
        message_recipient: message.message_recipient,
        DT_RowId: message.id
      }
    end
  end

  def get_raw_records
    # insert query here
    # User.all
    MarketingCampaign.all
  end
end
