require "test_helper"

module Blogposts::Show
  class ServiceTest < ActiveSupport::TestCase
    test "returns blogpost when found and published" do
      blogpost = blogposts(:first_blogpost)
      result = Service.call(slug: blogpost.slug)

      assert result.success?
      assert_equal blogpost, result.data[:blogpost]
    end

    test "returns failure when blogpost not found" do
      result = Service.call(slug: "non-existent-slug")

      assert result.failure?
      assert_instance_of Servus::Support::Errors::NotFoundError, result.error
    end

    test "returns failure when blogpost is not published" do
      blogpost = blogposts(:first_blogpost)
      blogpost.update(published_at: nil)
      result = Service.call(slug: blogpost.slug)

      assert result.failure?
      assert_instance_of Servus::Support::Errors::NotFoundError, result.error
    end

    test "returns failure when blogpost is published in the future" do
      blogpost = blogposts(:first_blogpost)
      blogpost.update(published_at: 1.day.from_now)
      result = Service.call(slug: blogpost.slug)

      assert result.failure?
      assert_instance_of Servus::Support::Errors::NotFoundError, result.error
    end
  end
end
