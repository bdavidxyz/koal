require "test_helper"

class Fuzzy::SearchTest < ActiveSupport::TestCase
  test "returns the original scope when the query is blank" do
    scope = Blogpost.where(id: blogposts(:first_blogpost).id)

    result = Fuzzy::Search.call(scope: scope, query: "   ")

    assert result.success?
    assert_equal [ blogposts(:first_blogpost).id ], result.data[:results].pluck(:id)
  end

  test "filters using the scope model searchable attributes" do
    result = Fuzzy::Search.call(scope: Blogpost.all, query: "authentication")

    assert result.success?
    assert_equal [ blogposts(:second_blogpost).id ], result.data[:results].pluck(:id)
  end

  test "keeps existing scope constraints when searching" do
    scope = Blogpost.where(id: blogposts(:first_blogpost).id)

    result = Fuzzy::Search.call(scope: scope, query: "authentication")

    assert result.success?
    assert_empty result.data[:results]
  end
end
