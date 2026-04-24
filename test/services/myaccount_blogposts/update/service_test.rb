require "test_helper"

class MyaccountBlogposts::Update::ServiceTest < ActiveSupport::TestCase
  test "updates a blogpost and replaces blogtag associations" do
    blogpost = blogposts(:first_blogpost)
    second_blogtag = blogtags(:second_blogtag)

    result = MyaccountBlogposts::Update::Service.call(
      blogpost: blogpost,
      attributes: {
        title: "Updated through Servus",
        slug: blogpost.slug,
        chapo: "Updated chapo",
        kontent: "Updated body",
        published_at: blogpost.published_at
      },
      blogtag_ids: [ second_blogtag.id, "" ]
    )

    assert result.success?
    assert_equal "Updated through Servus", blogpost.reload.title
    assert_equal [ second_blogtag.id ], blogpost.blogtags.order(:id).pluck(:id)
  end

  test "removes all blogtag associations when passed an empty list" do
    blogpost = blogposts(:first_blogpost)

    result = MyaccountBlogposts::Update::Service.call(
      blogpost: blogpost,
      attributes: {
        title: blogpost.title,
        slug: blogpost.slug,
        chapo: blogpost.chapo,
        kontent: blogpost.kontent,
        published_at: blogpost.published_at
      },
      blogtag_ids: []
    )

    assert result.success?
    assert_empty blogpost.reload.blogtags
  end

  test "returns the invalid blogpost on validation failure" do
    blogpost = blogposts(:first_blogpost)
    original_blogtag_ids = blogpost.blogtag_ids.sort

    result = MyaccountBlogposts::Update::Service.call(
      blogpost: blogpost,
      attributes: {
        title: "",
        slug: blogpost.slug,
        chapo: blogpost.chapo,
        kontent: blogpost.kontent,
        published_at: blogpost.published_at
      },
      blogtag_ids: [ blogtags(:second_blogtag).id ]
    )

    assert result.failure?
    assert_instance_of Blogpost, result.data[:blogpost]
    assert_includes result.data[:blogpost].errors[:title], "can't be blank"
    assert_equal original_blogtag_ids, blogpost.reload.blogtag_ids.sort
  end
end
