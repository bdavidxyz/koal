require "test_helper"

class MyaccountBlogposts::Destroy::ServiceTest < ActiveSupport::TestCase
  test "destroys the requested blogpost" do
    blogpost = blogposts(:first_blogpost)

    result = nil

    assert_difference("Blogpost.count", -1) do
      result = MyaccountBlogposts::Destroy::Service.call(slug: blogpost.slug)
    end

    assert result.success?
    assert result.data[:blogpost].destroyed?
  end

  test "returns not found when the blogpost does not exist" do
    result = MyaccountBlogposts::Destroy::Service.call(slug: "missing-blogpost")

    assert result.failure?
    assert_equal :not_found, result.error.http_status
  end
end
