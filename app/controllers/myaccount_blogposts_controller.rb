class MyaccountBlogpostsController < ApplicationController
  include Pagy::Method


  require_auth action: :index
  grant_access action: :index, roles: [ :superadmin ]
  # @route GET /myaccount/blogposts (myaccount_blogpost)
  def index
    @result = MyaccountBlogposts::Index::Service.call(
      sort: params[:sort],
      direction: params[:direction],
      query: q
    )

    @pagy, @result.data[:blogposts] = pagy(:offset, @result.data[:blogposts], limit: 10)
  end


  require_auth action: :show
  grant_access action: :show, roles: [ :superadmin ]
  # @route GET /myaccount/blogposts/:slug
  def show
    run_service(MyaccountBlogposts::Show::Service, slug: params[:slug])
  end


  require_auth action: :new
  grant_access action: :new, roles: [ :superadmin ]
  # @route GET /myaccount/blogposts/new (myaccount_blogpost_new)
  def new
    run_service(MyaccountBlogposts::New::Service, nil)
  end


  require_auth action: :edit
  grant_access action: :edit, roles: [ :superadmin ]
  # @route GET /myaccount/blogposts/:slug/edit
  def edit
    run_service(MyaccountBlogposts::Edit::Service, slug: params[:slug])
  end


  require_auth action: :create
  grant_access action: :create, roles: [ :superadmin ]
  # @route POST /myaccount/blogposts (myaccount_blogpost)
  def create
    @result = MyaccountBlogposts::Create::Service.call(
      attributes: blogpost_without_blogtags_attrs,
      blogtag_ids: params.dig(:blogpost, :blogtag_ids)
    )

    if @result.success?
      redirect_to myaccount_blogpost_list_path, notice: "Blogpost was successfully created."
    else
      render :new, status: :unprocessable_content
    end
  end


  require_auth action: :update
  grant_access action: :update, roles: [ :superadmin ]
  # @route PUT /myaccount/blogposts/:slug
  def update
    @result = MyaccountBlogposts::Update::Service.call(
      slug: params[:slug],
      attributes: blogpost_without_blogtags_attrs,
      blogtag_ids: params.dig(:blogpost, :blogtag_ids)
    )

    if @result.success?
      redirect_to myaccount_blogpost_list_path, notice: "Blogpost was successfully updated."
    elsif @result.error&.http_status == :not_found
      render_service_error(@result.error)
    else
      render :edit, status: :unprocessable_content
    end
  end


  require_auth action: :destroy
  grant_access action: :destroy, roles: [ :superadmin ]
  # @route DELETE /myaccount/blogposts/:slug
  def destroy
    @result = MyaccountBlogposts::Destroy::Service.call(slug: params[:slug])

    if @result.success?
      redirect_to myaccount_path, notice: "Blogpost was successfully deleted."
    else
      render_service_error(@result.error)
    end
  end

  private

  def blogpost_without_blogtags_attrs
    params.require(:blogpost).permit(:title, :kontent, :slug, :chapo, :published_at).to_h
  end
end
