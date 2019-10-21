# frozen_string_literal: true

class MpesaTransaction < ApplicationRecord
  def self.total_revenue_by_month
    # create an array of months
    months = *(1..12)
    # map each total revenue to month
    months.map { |month| [MpesaTransaction.where('extract(month from created_at) = ?', month).sum(:amount).to_f] }.flatten
  end

  def full_name
    if middle_name.present?
      "#{first_name} #{middle_name} #{last_name}"
    else
      "#{first_name} #{last_name}"
    end
  end
end
