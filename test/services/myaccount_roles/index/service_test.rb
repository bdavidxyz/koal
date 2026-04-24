require "test_helper"

class MyaccountRoles::Index::ServiceTest < ActiveSupport::TestCase
  test "returns roles ordered by updated_at desc by default" do
    older_role = Rabarber::Role.create!(name: "older_role")
    newer_role = Rabarber::Role.create!(name: "newer_role")

    older_role.update_columns(updated_at: 2.days.ago)
    newer_role.update_columns(updated_at: 1.day.ago)

    result = MyaccountRoles::Index::Service.call(sort: nil, direction: nil, query: nil)

    assert result.success?
    assert_equal [ newer_role.id, older_role.id ], result.data[:roles].where(id: [ older_role.id, newer_role.id ]).pluck(:id)
  end

  test "filters roles by name case insensitively" do
    matching_role = Rabarber::Role.create!(name: "support_team")
    Rabarber::Role.create!(name: "finance_team")

    result = MyaccountRoles::Index::Service.call(sort: "name", direction: "asc", query: "support")

    assert result.success?
    assert_equal [ matching_role.id ], result.data[:roles].pluck(:id)
  end

  test "falls back to the default sort when params are not allowlisted" do
    first_role = Rabarber::Role.create!(name: "fallback_first")
    last_role = Rabarber::Role.create!(name: "fallback_last")

    first_role.update_columns(updated_at: 3.days.ago)
    last_role.update_columns(updated_at: 1.hour.ago)

    result = MyaccountRoles::Index::Service.call(sort: "DROP TABLE roles", direction: "sideways", query: nil)

    assert result.success?
    assert_equal [ last_role.id, first_role.id ], result.data[:roles].where(id: [ first_role.id, last_role.id ]).pluck(:id)
  end
end
