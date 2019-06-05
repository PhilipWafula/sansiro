# frozen_string_literal: true

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  address: 'smtp.sendgrid.net',
  port: '587',
  authentication: :plain,
  user_name: Rails.application.secrets.heroku_send_grid_username,
  password: Rails.application.secret.heroku_send_grid_password,
  domain: 'heroku.com',
  enable_starttls_auto: true
}
