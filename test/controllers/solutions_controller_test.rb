require "test_helper"

class SolutionsControllerTest < ActionDispatch::IntegrationTest
  test "should get analytics" do
    get solutions_analytics_url
    assert_response :success
  end

  test "should get automation" do
    get solutions_automation_url
    assert_response :success
  end

  test "should get commerce" do
    get solutions_commerce_url
    assert_response :success
  end

  test "should get insights" do
    get solutions_insights_url
    assert_response :success
  end
end
