require 'test_helper'

class Frontend::HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get frontend_home_index_url
    assert_response :success
  end

end
