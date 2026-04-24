require "test_helper"

class MyaccountBlogposts::Create::ServiceTest < ActiveSupport::TestCase
  test "creates a blogpost with blogtag associations" do
    first_blogtag = blogtags(:first_blogtag)
    second_blogtag = blogtags(:second_blogtag)

    result = MyaccountBlogposts::Create::Service.call(
      attributes: {
        title: "Service Created Blogpost",
        slug: "service-created-blogpost",
        chapo: "Created through Servus",
        kontent: "Body content",
        published_at: Time.current
      },
      blogtag_ids: [ first_blogtag.id, second_blogtag.id, "" ]
    )

    assert result.success?
    assert_equal "Service Created Blogpost", result.data[:blogpost].title
    assert_equal [ first_blogtag.id, second_blogtag.id ], result.data[:blogpost].blogtags.order(:id).pluck(:id)
  end

  test "creates a blogpost without blogtag associations when none are provided" do
    result = MyaccountBlogposts::Create::Service.call(
      attributes: {
        title: "Untagged Blogpost",
        slug: "untagged-blogpost"
      },
      blogtag_ids: nil
    )

    assert result.success?
    assert_empty result.data[:blogpost].blogtags
  end

  test "returns the invalid blogpost on validation failure" do
    result = MyaccountBlogposts::Create::Service.call(
      attributes: {
        title: "",
        slug: "invalid-blogpost"
      },
      blogtag_ids: [ blogtags(:first_blogtag).id ]
    )

    assert result.failure?
    assert_instance_of Blogpost, result.data[:blogpost]
    assert_includes result.data[:blogpost].errors[:title], "can't be blank"
    assert_not result.data[:blogpost].persisted?
  end
end
