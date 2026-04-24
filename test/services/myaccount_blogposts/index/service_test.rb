require "test_helper"

class MyaccountBlogposts::Index::ServiceTest < ActiveSupport::TestCase
  test "returns blogposts ordered by updated_at desc by default" do
    older_blogpost = Blogpost.create!(title: "Older Blogpost", slug: "older-blogpost")
    newer_blogpost = Blogpost.create!(title: "Newer Blogpost", slug: "newer-blogpost")

    older_blogpost.update_columns(updated_at: 2.days.ago)
    newer_blogpost.update_columns(updated_at: 1.day.ago)

    result = MyaccountBlogposts::Index::Service.call(sort: nil, direction: nil, query: nil)

    assert result.success?
    assert_equal [ newer_blogpost.id, older_blogpost.id ], result.data[:blogposts].where(id: [ older_blogpost.id, newer_blogpost.id ]).pluck(:id)
  end

  test "filters blogposts with fuzzy search" do
    matching_blogpost = Blogpost.create!(
      title: "Scaling Rails Apps",
      slug: "scaling-rails-apps",
      chapo: "How to keep response times low"
    )
    Blogpost.create!(
      title: "Design Systems",
      slug: "design-systems",
      chapo: "Reusable UI patterns"
    )

    result = MyaccountBlogposts::Index::Service.call(sort: "title", direction: "asc", query: "scaling")

    assert result.success?
    assert_equal [ matching_blogpost.id ], result.data[:blogposts].pluck(:id)
  end

  test "falls back to the default sort when params are not allowlisted" do
    first_blogpost = Blogpost.create!(title: "Fallback First", slug: "fallback-first")
    last_blogpost = Blogpost.create!(title: "Fallback Last", slug: "fallback-last")

    first_blogpost.update_columns(updated_at: 3.days.ago)
    last_blogpost.update_columns(updated_at: 1.hour.ago)

    result = MyaccountBlogposts::Index::Service.call(sort: "DROP TABLE blogposts", direction: "sideways", query: nil)

    assert result.success?
    assert_equal [ last_blogpost.id, first_blogpost.id ], result.data[:blogposts].where(id: [ first_blogpost.id, last_blogpost.id ]).pluck(:id)
  end
end
