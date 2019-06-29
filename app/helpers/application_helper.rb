# frozen_string_literal: true

module ApplicationHelper
  def gravatar_url(email)
    gravatar = Digest::MD5.hexdigest(email).downcase
    "https://gravatar.com/avatar/#{gravatar}.png"
  end
end