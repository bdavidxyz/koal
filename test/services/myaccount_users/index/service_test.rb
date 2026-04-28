require "test_helper"

class MyaccountUsers::Index::ServiceTest < ActiveSupport::TestCase
  test "returns users ordered by updated_at desc by default" do
    older_user = User.create!(email: "older@example.com", password: "password12345", password_confirmation: "password12345")
    newer_user = User.create!(email: "newer@example.com", password: "password12345", password_confirmation: "password12345")

    older_user.update_columns(updated_at: 2.days.ago)
    newer_user.update_columns(updated_at: 1.day.ago)

    result = MyaccountUsers::Index::Service.call(sort: nil, direction: nil, query: nil)

    assert result.success?
    assert_equal [ newer_user.id, older_user.id ], result.data[:users].where(id: [ older_user.id, newer_user.id ]).pluck(:id)
  end

  test "filters users with fuzzy search" do
    matching_user = User.create!(email: "matching@example.com", password: "password12345", password_confirmation: "password12345", name: "John Doe")
    other_user = User.create!(email: "other@example.com", password: "password12345", password_confirmation: "password12345", name: "Jane Smith")

    result = MyaccountUsers::Index::Service.call(sort: "email", direction: "asc", query: "matching")

    assert result.success?
    assert_includes result.data[:users].pluck(:id), matching_user.id
    assert_not_includes result.data[:users].pluck(:id), other_user.id
  end

  test "falls back to the default sort when params are not allowlisted" do
    first_user = User.create!(email: "first@example.com", password: "password12345", password_confirmation: "password12345")
    last_user = User.create!(email: "last@example.com", password: "password12345", password_confirmation: "password12345")

    first_user.update_columns(updated_at: 3.days.ago)
    last_user.update_columns(updated_at: 1.hour.ago)

    result = MyaccountUsers::Index::Service.call(sort: "DROP TABLE users", direction: "sideways", query: nil)

    assert result.success?
    assert_equal [ last_user.id, first_user.id ], result.data[:users].where(id: [ first_user.id, last_user.id ]).pluck(:id)
  end
end
