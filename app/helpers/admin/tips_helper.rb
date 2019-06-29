# frozen_string_literal: true

module Admin::TipsHelper
  def twelve_hour_format(time)
    time.strftime('%I:%M %p').to_s
  end
end
