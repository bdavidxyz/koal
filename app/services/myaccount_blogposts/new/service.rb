module MyaccountBlogposts::New
  class Service < Servus::Base
    def call
      success(blogpost: Blogpost.new)
    end
  end
end
