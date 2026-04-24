class BlogpostsController < ApplicationController
  include Pagy::Method

  grant_access action: :index
  # @route GET /blogposts (blogposts)
  def index
    sort = {}
    if params[:sort] && params[:direction]
      sort[params[:sort]] = params[:direction]
    else
      sort[:published_at] = "desc"
    end
    scope = Blogpost.includes(:blogtags).where("published_at IS NOT NULL AND published_at <= ?", Time.current).order(sort)
    blogposts = Fuzzy::Search.call(scope: scope, query: params[:q]).data[:results]
    @pagy, @blogposts = pagy(:offset, blogposts, limit: 10)
  end

  grant_access action: :show
  # @route GET /blogposts/:slug
  def show
    @blogpost = retrieve_blogpost
  end

  private

  def retrieve_blogpost
    blogpost = Blogpost.find_by(slug: params[:slug])
    if blogpost.nil? || blogpost.published_at.nil? || blogpost.published_at > Time.current
      not_found
    else
      blogpost
    end
  end
end
