require 'test_helper'

class Admin::TransactionsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_transactions_index_url
    assert_response :success
  end

end
