require "test_helper"

class MyaccountBlogposts::New::ServiceTest < ActiveSupport::TestCase
  test "returns a new blogpost" do
    result = MyaccountBlogposts::New::Service.call

    assert result.success?
    assert_instance_of Blogpost, result.data[:blogpost]
    assert result.data[:blogpost].new_record?
  end
end
