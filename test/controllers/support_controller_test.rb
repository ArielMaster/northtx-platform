require "test_helper"

class SupportControllerTest < ActionDispatch::IntegrationTest
  test "should get submit_ticket" do
    get support_submit_ticket_url
    assert_response :success
  end

  test "should get documentation" do
    get support_documentation_url
    assert_response :success
  end

  test "should get guides" do
    get support_guides_url
    assert_response :success
  end
end
