require "test_helper"

class Pages::HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get about" do
    get pages_home_about_url
    assert_response :success
  end

  test "should get services" do
    get pages_home_services_url
    assert_response :success
  end

  test "should get portfolio" do
    get pages_home_portfolio_url
    assert_response :success
  end

  test "should get pricing" do
    get pages_home_pricing_url
    assert_response :success
  end

  test "should get blog" do
    get pages_home_blog_url
    assert_response :success
  end

  test "should get contact" do
    get pages_home_contact_url
    assert_response :success
  end
end
