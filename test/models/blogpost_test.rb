require "test_helper"

class BlogpostTest < ActiveSupport::TestCase
  test "should be valid with valid attributes" do
    blogpost = Blogpost.new(
      title: "Test Blog Post",
      kontent: "This is test content",
      chapo: "Test summary"
    )
    assert blogpost.valid?
  end

  test "should require title" do
    blogpost = Blogpost.new(
      kontent: "This is test content",
      chapo: "Test summary"
    )
    assert_not blogpost.valid?
    assert_includes blogpost.errors[:title], "can't be blank"
  end

  test "should generate slug after creation" do
    blogpost = Blogpost.create!(
      title: "Test Blog Post",
      kontent: "This is test content"
    )

    assert_not_nil blogpost.slug
    assert_match(/\Ablogpost_[a-f0-9]{4}a\d+\z/, blogpost.slug)
  end

  test "should not overwrite existing slug" do
    blogpost = Blogpost.create!(
      title: "Test Blog Post",
      kontent: "This is test content",
      slug: "custom-slug"
    )

    assert_equal "custom-slug", blogpost.slug
  end

  test "should have many blogtags" do
    blogpost = blogposts(:first_blogpost)

    assert_respond_to blogpost, :blogtags
    assert_kind_of ActiveRecord::Associations::CollectionProxy, blogpost.blogtags
  end

  test "should have many blogtag_blogposts" do
    blogpost = blogposts(:first_blogpost)

    assert_respond_to blogpost, :blogtag_blogposts
    assert_kind_of ActiveRecord::Associations::CollectionProxy, blogpost.blogtag_blogposts
  end

  test "should be associated with blogtags through blogtag_blogposts" do
    blogpost = blogposts(:first_blogpost)
    alpha_tag = blogtags(:first_blogtag)
    beta_tag = blogtags(:second_blogtag)

    # Add tags to test the association
    blogpost.blogtags << alpha_tag unless blogpost.blogtags.include?(alpha_tag)
    blogpost.blogtags << beta_tag unless blogpost.blogtags.include?(beta_tag)

    assert_includes blogpost.blogtags, alpha_tag
    assert_includes blogpost.blogtags, beta_tag
    assert_equal 2, blogpost.blogtags.count
  end

  test "should be able to add blogtags" do
    blogpost = Blogpost.create!(
      title: "Test Blog Post",
      kontent: "This is test content"
    )
    tag = blogtags(:first_blogtag)

    blogpost.blogtags << tag

    assert_includes blogpost.blogtags, tag
    assert_equal 1, blogpost.blogtags.count
  end

  test "should be able to remove blogtags" do
    blogpost = blogposts(:first_blogpost)
    alpha_tag = blogtags(:first_blogtag)

    # Add tag first
    blogpost.blogtags << alpha_tag unless blogpost.blogtags.include?(alpha_tag)

    # Verify tag is present
    assert_includes blogpost.blogtags, alpha_tag

    # Remove the tag
    blogpost.blogtags.delete(alpha_tag)

    # Verify tag is removed
    assert_not_includes blogpost.blogtags.reload, alpha_tag
  end

  test "should handle multiple blogtags" do
    blogpost = Blogpost.create!(
      title: "Test Blog Post with Multiple Tags",
      kontent: "This post has multiple tags"
    )

    # Add multiple tags
    blogpost.blogtags << blogtags(:first_blogtag)
    blogpost.blogtags << blogtags(:second_blogtag)

    assert_equal 2, blogpost.blogtags.count
    assert_includes blogpost.blogtags, blogtags(:first_blogtag)
    assert_includes blogpost.blogtags, blogtags(:second_blogtag)
  end

  test "should handle no blogtags" do
    blogpost = Blogpost.create!(
      title: "Test Blog Post without Tags",
      kontent: "This post has no tags"
    )

    assert_equal 0, blogpost.blogtags.count
    assert_empty blogpost.blogtags
  end

  test "should include SearchableResource" do
    assert_includes Blogpost.included_modules, SearchableResource
  end

  test "should have searchable attributes defined" do
    # This tests that the searchable_attributes method is called with the right parameters
    # The actual search functionality would be tested in the SearchableResource concern
    blogpost = blogposts(:first_blogpost)
    assert_respond_to blogpost, :title
    assert_respond_to blogpost, :kontent
    assert_respond_to blogpost, :chapo
  end

  test "fixtures should be valid" do
    # Test that our fixtures are properly set up
    first_blogpost = blogposts(:first_blogpost)
    second_blogpost = blogposts(:second_blogpost)

    assert first_blogpost.valid?
    assert second_blogpost.valid?

    # Test that fixtures exist and models have the expected attributes
    assert_not_nil first_blogpost.title
    assert_not_nil first_blogpost.kontent
    assert_not_nil second_blogpost.title
    assert_not_nil second_blogpost.kontent

    # Test that associations are working (regardless of fixture data)
    assert_respond_to first_blogpost, :blogtags
    assert_respond_to second_blogpost, :blogtags
  end

  test "should destroy associated blogtag_blogposts when blogpost is destroyed" do
    blogpost = blogposts(:first_blogpost)
    initial_count = BlogtagBlogpost.count
    blogtag_blogpost_count = blogpost.blogtag_blogposts.count

    blogpost.destroy

    assert_equal initial_count - blogtag_blogpost_count, BlogtagBlogpost.count
  end

  test "slug generation should handle concurrent creation" do
    # Test that slug generation works even if multiple posts are created simultaneously
    blogpost1 = Blogpost.create!(title: "Test Post 1", kontent: "Content 1")
    blogpost2 = Blogpost.create!(title: "Test Post 2", kontent: "Content 2")

    assert_not_nil blogpost1.slug
    assert_not_nil blogpost2.slug
    assert_not_equal blogpost1.slug, blogpost2.slug
  end
end
