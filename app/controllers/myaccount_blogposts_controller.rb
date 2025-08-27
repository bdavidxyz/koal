class MyaccountBlogpostsController < ApplicationController
  include Pagy::Backend

  require_auth action: :index
  grant_access action: :index, roles: [ :superadmin ]
  # @route GET /myaccount/blogposts (myaccount_blogpost)
  def index
    sort = {}
    if params[:sort] && params[:direction]
      sort[params[:sort]] = params[:direction]
    else
      sort[:updated_at] = "desc"
    end
    scope = Blogpost.order(sort)
    blogposts = !!q ? Fuzzy::Search.new(scope, Blogpost, q).run : scope
    @pagy, @blogposts = pagy(blogposts, limit: 10)
  end

  require_auth action: :show
  grant_access action: :show, roles: [ :superadmin ]
  # @route GET /myaccount/blogposts/:slug
  def show
    @blogpost = retrieve_blogpost
  end

  require_auth action: :new
  grant_access action: :new, roles: [ :superadmin ]
  # @route GET /myaccount/blogposts/new (myaccount_blogpost_new)
  def new
    @blogpost = Blogpost.new
  end

  require_auth action: :edit
  grant_access action: :edit, roles: [ :superadmin ]
  # @route GET /myaccount/blogposts/:slug/edit
  def edit
    @blogpost = retrieve_blogpost
  end

  require_auth action: :create
  grant_access action: :create, roles: [ :superadmin ]
  # @route POST /myaccount/blogposts (myaccount_blogpost)
  def create
    @blogpost = Blogpost.new(blogpost_params)
    if @blogpost.save
      redirect_to myaccount_blogpost_list_path, notice: "Blogpost was successfully created."
    else
      render :new, status: :unprocessable_content
    end
  end

  require_auth action: :update
  grant_access action: :update, roles: [ :superadmin ]
  # @route PUT /myaccount/blogposts/:slug
  def update
    @blogpost = retrieve_blogpost
    if @blogpost.update(blogpost_params)
      redirect_to myaccount_blogpost_list_path, notice: "Blogpost was successfully updated."
    else
      render :edit, status: :unprocessable_content
    end
  end

  require_auth action: :destroy
  grant_access action: :destroy, roles: [ :superadmin ]
  # @route DELETE /myaccount/blogposts/:slug
  def destroy
    blogpost = retrieve_blogpost
    blogpost.destroy
    redirect_to myaccount_path, notice: "Blogpost was successfully deleted."
  end

  private

  def retrieve_blogpost
    Blogpost.find_by(slug: params[:slug]) or not_found
  end

  def blogpost_params
    params.require(:blogpost).permit(:title, :kontent, :slug, :chapo, :published_at)
  end
end
