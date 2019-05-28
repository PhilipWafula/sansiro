class Admin::DashboardController < AdminController
  before_action :authenticate_admin!
  def index; end
end
