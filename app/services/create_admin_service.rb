class CreateAdminService
  def call
    Admin.find_or_create_by!(email: Rails.application.credentials[Rails.env.to_sym][:admin_email]) do |admin|
      admin.password = Rails.application.credentials[Rails.env.to_sym][:admin_password]
      admin.password_confirmation = Rails.application.credentials[Rails.env.to_sym][:admin_password]
      admin.confirm
      admin.skip_confirmation!
    end
  end
end