# frozen_string_literal: true

class Tip < ApplicationRecord
  belongs_to :admin
  validates :tip_date, presence: true
end
