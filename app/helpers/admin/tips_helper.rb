# frozen_string_literal: true

module Admin::TipsHelper
  def twelve_hour_format(time)
    time.in_time_zone('Nairobi').strftime('%I:%M %p').to_s
  end
end
