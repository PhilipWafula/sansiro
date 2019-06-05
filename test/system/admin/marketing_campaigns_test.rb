require "application_system_test_case"

class Admin::MarketingCampaignsTest < ApplicationSystemTestCase
  setup do
    @admin_marketing_campaign = admin_marketing_campaigns(:one)
  end

  test "visiting the index" do
    visit admin_marketing_campaigns_url
    assert_selector "h1", text: "Admin/Marketing Campaigns"
  end

  test "creating a Marketing campaign" do
    visit admin_marketing_campaigns_url
    click_on "New Admin/Marketing Campaign"

    click_on "Create Marketing campaign"

    assert_text "Marketing campaign was successfully created"
    click_on "Back"
  end

  test "updating a Marketing campaign" do
    visit admin_marketing_campaigns_url
    click_on "Edit", match: :first

    click_on "Update Marketing campaign"

    assert_text "Marketing campaign was successfully updated"
    click_on "Back"
  end

  test "destroying a Marketing campaign" do
    visit admin_marketing_campaigns_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Marketing campaign was successfully destroyed"
  end
end
