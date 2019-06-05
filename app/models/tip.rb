# frozen_string_literal: true

class Tip < ApplicationRecord
  belongs_to :admin, touch: true
  validates :tip_date, presence: true

end
