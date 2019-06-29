# frozen_string_literal: true

class Tip < ApplicationRecord
  belongs_to :admin
  validates :tip_date, presence: true

  def self.tip_count_by_month
    # create an array of months
    months = *(1..12)
    # map each total revenue to month
    months.map { |month| [Tip.where('extract(month from tip_date) = ?', month).count(:id).to_i] }.flatten
  end

  def self.total_tips_generated
    Tip.all.count
  end
end
