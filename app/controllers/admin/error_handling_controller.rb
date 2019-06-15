class Admin::ErrorHandlingController < AdminController
  before_action :authenticate_admin!
  layout 'admin/application'

  def index; end

  def test_africas_talking
    puts 'METHOD REACHED'
    BulkSmsWorker.perform_async('+254706533739', 'TEST MESSAGE SENT')
    flash.now[notice: 'Test has been fired']
  end
end