require "test_helper"
require "ostruct"

class SolidErrorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_with_superadmin = users(:jane)     # has superadmin role
    @user_without_superadmin = users(:alicia) # only has member role
  end

  test "non-superadmin user cannot access solid_errors route" do
    sign_in_as(@user_without_superadmin)

    # Test that non-superadmin user gets 404 when trying to access solid_errors
    get "/solid_errors"
    assert_response :not_found
  end

  test "superadmin constraint allows access for superadmin user" do
    # Ensure the user has the superadmin role
    assert @user_with_superadmin.has_role?(:superadmin), "Jane should have superadmin role"

    # Test the constraint directly
    constraint = SuperadminConstraint.new

    # Create a mock request with a signed session cookie for the superadmin user
    session = @user_with_superadmin.sessions.create!
    mock_request = OpenStruct.new(
      cookie_jar: OpenStruct.new(
        signed: { session_token: session.id }
      )
    )

    # The constraint should return true for a superadmin user
    assert constraint.matches?(mock_request), "SuperadminConstraint should allow access for superadmin user"
  end

  test "superadmin constraint denies access for non-superadmin user" do
    # Ensure the user does not have superadmin role
    assert_not @user_without_superadmin.has_role?(:superadmin), "Alicia should not have superadmin role"

    # Test the constraint directly
    constraint = SuperadminConstraint.new

    # Create a mock request with a signed session cookie for the non-superadmin user
    session = @user_without_superadmin.sessions.create!
    mock_request = OpenStruct.new(
      cookie_jar: OpenStruct.new(
        signed: { session_token: session.id }
      )
    )

    # The constraint should return false for a non-superadmin user
    assert_not constraint.matches?(mock_request), "SuperadminConstraint should deny access for non-superadmin user"
  end

  test "unauthenticated user cannot access solid_errors route" do
    # Test that unauthenticated user gets 404 when trying to access solid_errors
    get "/solid_errors"
    assert_response :not_found
  end
end
