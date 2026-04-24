module MyaccountBlogposts::Show
  class Service < Servus::Base
    def initialize(slug:)
      @slug = slug
    end

    def call
      blogpost = Blogpost.find_by(slug: @slug)
      return failure("Blogpost not found", type: NotFoundError) unless blogpost

      success(blogpost: blogpost)
    end
  end
end
