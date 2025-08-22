require "test_helper"

class MyaccountRolesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = sign_in_as(users(:jane))
    # Clean up any test roles that might exist
    cleanup_test_roles
    # Create test roles for testing
    Rabarber::Role.add(:test_role) unless Rabarber::Role.names.include?(:test_role)
    Rabarber::Role.add(:another_test_role) unless Rabarber::Role.names.include?(:another_test_role)
  end

  teardown do
    cleanup_test_roles
  end

  test "should get index" do
    get myaccount_role_list_url
    assert_response :success
    assert_select "h1", "Roles"
  end

  test "should get index with sorting parameters" do
    get myaccount_role_list_url, params: { sort: "name", direction: "asc" }
    assert_response :success
  end

  test "should get index with search parameters" do
    get myaccount_role_list_url, params: { q: "test" }
    assert_response :success
  end

  test "should get new" do
    get myaccount_role_new_url
    assert_response :success
    assert_select "h1", "New Role"
  end

  test "should create role" do
    initial_roles = Rabarber::Role.names
    post myaccount_role_create_url, params: { role: { name: "new_test_role" } }
    
    assert_redirected_to myaccount_role_list_url
    assert_includes Rabarber::Role.names, :new_test_role
    assert_not_equal initial_roles.length, Rabarber::Role.names.length
    
    # Clean up
    Rabarber::Role.remove(:new_test_role, force: true) rescue nil
  end

  test "should not create role with blank name" do
    initial_roles = Rabarber::Role.names
    post myaccount_role_create_url, params: { role: { name: "" } }
    
    assert_response :unprocessable_content
    assert_template :new
    assert_equal initial_roles.length, Rabarber::Role.names.length
  end

  test "should not create role with duplicate name" do
    initial_roles = Rabarber::Role.names
    post myaccount_role_create_url, params: { role: { name: "test_role" } }
    
    assert_response :unprocessable_content
    assert_template :new
    assert_equal initial_roles.length, Rabarber::Role.names.length
  end

  test "should show role" do
    get myaccount_role_show_url(name: "test_role")
    assert_response :success
    assert_select "h1", text: /Role: test_role/
  end

  test "should return 404 for non-existent role" do
    get myaccount_role_show_url(name: "non_existent_role")
    assert_response :not_found
  end

  test "should get edit" do
    get myaccount_role_edit_url(name: "test_role")
    assert_response :success
    assert_select "h1", "Edit Role"
  end

  test "should update role" do
    put myaccount_role_update_url(name: "test_role"), params: { role: { name: "renamed_test_role" } }
    
    assert_redirected_to myaccount_role_list_url
    assert_includes Rabarber::Role.names, :renamed_test_role
    assert_not_includes Rabarber::Role.names, :test_role
    
    # Rename back for consistency
    Rabarber::Role.rename(:renamed_test_role, :test_role, force: true) rescue nil
  end

  test "should not update role with blank name" do
    put myaccount_role_update_url(name: "test_role"), params: { role: { name: "" } }
    
    assert_response :unprocessable_content
    assert_template :edit
    assert_includes Rabarber::Role.names, :test_role
  end

  test "should not update role with duplicate name" do
    put myaccount_role_update_url(name: "test_role"), params: { role: { name: "another_test_role" } }
    
    assert_response :unprocessable_content
    assert_template :edit
    assert_includes Rabarber::Role.names, :test_role
    assert_includes Rabarber::Role.names, :another_test_role
  end

  test "should destroy role" do
    # Create a role specifically for deletion
    Rabarber::Role.add(:role_to_delete) unless Rabarber::Role.names.include?(:role_to_delete)
    
    assert_includes Rabarber::Role.names, :role_to_delete
    delete myaccount_role_destroy_url(name: "role_to_delete")
    
    assert_redirected_to myaccount_url
    assert_not_includes Rabarber::Role.names, :role_to_delete
  end

  test "should handle destroy error gracefully" do
    # Test with a non-existent role to trigger error handling
    delete myaccount_role_destroy_url(name: "non_existent_role")
    assert_response :not_found
  end

  test "index should display role information correctly" do
    get myaccount_role_list_url
    assert_response :success
    
    # Check that the roles are displayed
    assert_select "td", text: "test_role"
    assert_select "td", text: "another_test_role"
    
    # Check for action buttons
    assert_select "a", text: "Edit"
    assert_select "a", text: "Show"
  end

  test "show should display assignees when role has users" do
    # Assign the role to current user for testing
    @user.assign_roles(:test_role)
    
    get myaccount_role_show_url(name: "test_role")
    assert_response :success
    
    # Should show the user in assignees section
    assert_select "td", text: @user.email
    
    # Clean up
    @user.revoke_roles(:test_role)
  end

  test "show should display no assignees message when role has no users" do
    get myaccount_role_show_url(name: "test_role")
    assert_response :success
    
    assert_select "p", text: "No users have been assigned this role yet."
  end

  private

  def cleanup_test_roles
    test_roles = [:test_role, :another_test_role, :new_test_role, :renamed_test_role, :role_to_delete]
    test_roles.each do |role|
      Rabarber::Role.remove(role, force: true) if Rabarber::Role.names.include?(role)
    rescue
      # Ignore errors during cleanup
    end
  end
end