require 'test_helper'

class Admin::MarketingCampaignsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_marketing_campaign = admin_marketing_campaigns(:one)
  end

  test "should get index" do
    get admin_marketing_campaigns_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_marketing_campaign_url
    assert_response :success
  end

  test "should create admin_marketing_campaign" do
    assert_difference('Admin::MarketingCampaign.count') do
      post admin_marketing_campaigns_url, params: { admin_marketing_campaign: {  } }
    end

    assert_redirected_to admin_marketing_campaign_url(Admin::MarketingCampaign.last)
  end

  test "should show admin_marketing_campaign" do
    get admin_marketing_campaign_url(@admin_marketing_campaign)
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_marketing_campaign_url(@admin_marketing_campaign)
    assert_response :success
  end

  test "should update admin_marketing_campaign" do
    patch admin_marketing_campaign_url(@admin_marketing_campaign), params: { admin_marketing_campaign: {  } }
    assert_redirected_to admin_marketing_campaign_url(@admin_marketing_campaign)
  end

  test "should destroy admin_marketing_campaign" do
    assert_difference('Admin::MarketingCampaign.count', -1) do
      delete admin_marketing_campaign_url(@admin_marketing_campaign)
    end

    assert_redirected_to admin_marketing_campaigns_url
  end
end
