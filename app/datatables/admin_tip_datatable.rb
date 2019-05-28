class AdminTipDatatable < AjaxDatatablesRails::ActiveRecord

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      # id: { source: "User.id", cond: :eq },
      # name: { source: "User.name", cond: :like }
      id: { source: 'Admin::Tip.id' },
      tip_package: { source: 'Admin::Tip.tip_package' },
      tip_date: { source: 'Admin::Tip.tip_date' },
      tip_content: { source: 'Admin::Tip.tip_content' }
    }
  end

  def data
    records.map do |record|
      {
        # example:
        # id: record.id,
        # name: record.name
        id: record.id,
        tip_package: record.tip_package,
        tip_date: record.tip_date,
        tip_content: record.tip_content,
        DT_RowId: record.id
      }
    end
  end

  def get_raw_records
    # insert query here
    # User.all
    Admin::Tip.all
  end

end
