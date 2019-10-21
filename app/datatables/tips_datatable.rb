class TipsDatatable < AjaxDatatablesRails::ActiveRecord

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      # id: { source: "User.id", cond: :eq },
      # name: { source: "User.name", cond: :like }
      id: { source: 'Tip.id' },
      tip_package: { source: 'Tip.tip_package' },
      tip_sender: { source: 'Tip.tip_sender' },
      tip_date: { source: 'Tip.tip_date' },
      tip_expiry: { source: 'Tip.tip_expiry' },
      tip_content: { source: 'Tip.tip_content' }
    }
  end

  def data
    records.map do |tip|
      {
        # example:
        # id: tip.id,
        # name: tip.name
        id: tip.id,
        tip_package: tip.tip_package,
        tip_sender: tip.tip_sender,
        tip_date: tip.tip_date,
        tip_expiry: tip.tip_expiry&.strftime('%d-%m-%Y, %I:%M %p'),
        tip_content: tip.tip_content,
        DT_RowId: tip.id
      }
    end
  end

  def get_raw_records
    # insert query here
    # User.all
    Tip.all
  end

end
