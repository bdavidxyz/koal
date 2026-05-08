class BlogpostsController < ApplicationController
  include Pagy::Method

  grant_access action: :index
  # @route GET /blogposts (blogposts)
  def index
    @result = Blogposts::Index::Service.call(
      sort: params[:sort],
      direction: params[:direction],
      query: params[:q]
    )

    if @result.success?
      @pagy, @blogposts = pagy(:offset, @result.data[:blogposts], limit: 10)
    else
      redirect_to root_path, alert: "Unable to load blogposts"
    end
  end

  grant_access action: :show
  # @route GET /blogposts/:slug
  def show
    @result = Blogposts::Show::Service.call(slug: params[:slug])

    if @result.success?
      @blogpost = @result.data[:blogpost]
    else
      not_found
    end
  end
end
