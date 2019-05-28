require "application_system_test_case"

class Admin::TipsTest < ApplicationSystemTestCase
  setup do
    @admin_tip = admin_tips(:one)
  end

  test "visiting the index" do
    visit admin_tips_url
    assert_selector "h1", text: "Admin/Tips"
  end

  test "creating a Tip" do
    visit admin_tips_url
    click_on "New Admin/Tip"

    click_on "Create Tip"

    assert_text "Tip was successfully created"
    click_on "Back"
  end

  test "updating a Tip" do
    visit admin_tips_url
    click_on "Edit", match: :first

    click_on "Update Tip"

    assert_text "Tip was successfully updated"
    click_on "Back"
  end

  test "destroying a Tip" do
    visit admin_tips_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Tip was successfully destroyed"
  end
end
