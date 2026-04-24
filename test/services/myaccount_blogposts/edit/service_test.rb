require "test_helper"

class MyaccountBlogposts::Edit::ServiceTest < ActiveSupport::TestCase
  test "returns the requested blogpost" do
    blogpost = blogposts(:first_blogpost)

    result = MyaccountBlogposts::Edit::Service.call(slug: blogpost.slug)

    assert result.success?
    assert_equal blogpost, result.data[:blogpost]
  end

  test "returns not found when the blogpost does not exist" do
    result = MyaccountBlogposts::Edit::Service.call(slug: "missing-blogpost")

    assert result.failure?
    assert_equal :not_found, result.error.http_status
  end
end
