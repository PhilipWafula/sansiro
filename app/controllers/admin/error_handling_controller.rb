class Admin::ErrorHandlingController < AdminController
  before_action :authenticate_admin!
  layout 'admin/application'

  def index; end

  def test_africas_talking
    @current_admin = Admin.find(current_admin.id)
    @sample_tip = @current_admin.tips.new
    ErrorHandlingService.new(@sample_tip).perform
  end

  def test_create_tip; end

  private

  def test_tip_params
    params.require(:tip).permit(:tip_package, :tip_expiry, :tip_date, :tip_content)
  end
end