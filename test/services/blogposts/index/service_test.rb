require "test_helper"

module Blogposts::Index
  class ServiceTest < ActiveSupport::TestCase
    test "returns published blogposts sorted by published_at desc by default" do
      result = Service.call(sort: nil, direction: nil, query: nil)

      assert result.success?
      assert_not_nil result.data[:blogposts]
    end

    test "returns blogposts sorted by custom field" do
      result = Service.call(sort: "title", direction: "asc", query: nil)

      assert result.success?
      assert_not_nil result.data[:blogposts]
    end

    test "filters blogposts by query" do
      result = Service.call(sort: nil, direction: nil, query: "test")

      assert result.success?
      assert_not_nil result.data[:blogposts]
    end
  end
end
