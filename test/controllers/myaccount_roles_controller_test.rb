require "test_helper"

class MyaccountRolesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = sign_in_as(users(:jane))
    @role = Rabarber::Role.find_by(name: "member")
  end

  test "should get index" do
    get myaccount_role_list_url
    assert_response :success
  end

  test "should get index with sort and direction parameters" do
    get myaccount_role_list_url, params: { sort: "name", direction: "asc", q: "" }
    assert_response :success
  end

  test "should get new" do
    get myaccount_role_new_url
    assert_response :success
  end

  test "should create role" do
    assert_difference("Rabarber::Role.count") do
      post myaccount_role_create_url, params: { rabarber_role: { name: "admin" } }
    end

    assert_redirected_to myaccount_role_list_url
  end

  test "should show role" do
    get myaccount_role_show_url(id: @role.id)
    assert_response :success
  end

  test "should get edit" do
    get myaccount_role_edit_url(id: @role.id)
    assert_response :success
  end

  test "should update role" do
    put myaccount_role_update_url(id: @role.id), params: { rabarber_role: { name: @role.name } }
    assert_redirected_to myaccount_role_list_url
  end

  test "should destroy role" do
    assert_difference("Rabarber::Role.count", -1) do
      delete myaccount_role_destroy_url(id: @role.id)
    end

    assert_redirected_to myaccount_url
  end

  test "should not create role with invalid params" do
    assert_no_difference("Rabarber::Role.count") do
      post myaccount_role_create_url, params: { rabarber_role: { name: "" } }
    end

    assert_response :unprocessable_content
    assert_template :new
  end

  test "should not update role with invalid params" do
    put myaccount_role_update_url(id: @role.id), params: { rabarber_role: { name: "" } }
    assert_response :unprocessable_content
    assert_template :edit
  end

  test "should not create role with name too short" do
    assert_no_difference("Rabarber::Role.count") do
      post myaccount_role_create_url, params: { rabarber_role: { name: "X" } }
    end

    assert_response :unprocessable_content
    assert_template :new
  end

  test "should not create role with duplicate name" do
    assert_no_difference("Rabarber::Role.count") do
      post myaccount_role_create_url, params: { rabarber_role: { name: @role.name } }
    end

    assert_response :unprocessable_content
    assert_template :new
  end

  test "should handle search with query parameter" do
    get myaccount_role_list_url, params: { q: "member" }
    assert_response :success
  end

  test "should return 404 for non-existent role" do
    get myaccount_role_show_url(id: 999999)
    assert_response :not_found
  end
end
