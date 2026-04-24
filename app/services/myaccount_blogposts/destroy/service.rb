module MyaccountBlogposts::Destroy
  class Service < Servus::Base
    def initialize(slug:)
      @slug = slug
    end

    def call
      blogpost = Blogpost.find_by(slug: @slug)
      return failure("Blogpost not found", type: NotFoundError) unless blogpost

      return failure("Blogpost could not be deleted", data: { blogpost: blogpost }) unless destroy(blogpost)

      success(blogpost: blogpost)
    end

    private
      def destroy(blogpost)
        blogpost.destroy
        blogpost.destroyed?
      end
  end
end
