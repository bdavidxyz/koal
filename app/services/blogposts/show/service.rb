module Blogposts::Show
  class Service < Servus::Base
    def initialize(slug:)
      @slug = slug
    end

    def call
      blogpost = Blogpost.find_by(slug: @slug)

      if blogpost.nil? || blogpost.published_at.nil? || blogpost.published_at > Time.current
        return failure("Blogpost not found", type: NotFoundError)
      end

      success(blogpost: blogpost)
    end
  end
end
