require "test_helper"

class Project::BugsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get project_bugs_index_url
    assert_response :success
  end

  test "should get show" do
    get project_bugs_show_url
    assert_response :success
  end

  test "should get new" do
    get project_bugs_new_url
    assert_response :success
  end

  test "should get edit" do
    get project_bugs_edit_url
    assert_response :success
  end
end
