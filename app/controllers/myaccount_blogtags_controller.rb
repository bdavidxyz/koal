class MyaccountBlogtagsController < ApplicationController
  include Pagy::Method

  require_auth action: :index
  grant_access action: :index, roles: [ :superadmin ]
  # @route GET /myaccount/blogtags (myaccount_blogtag)
  def index
    @result = MyaccountBlogtags::Index::Service.call(
      sort: params[:sort],
      direction: params[:direction],
      query: q
    )

    @pagy, @result.data[:blogtags] = pagy(:offset, @result.data[:blogtags], limit: 10)
    @blogtags = @result.data[:blogtags]
  end

  require_auth action: :show
  grant_access action: :show, roles: [ :superadmin ]
  # @route GET /myaccount/blogtags/:slug
  def show
    @result = MyaccountBlogtags::Show::Service.call(slug: params[:slug])

    if @result.success?
      @blogtag = @result.data[:blogtag]
    else
      render_error_page(@result.error.http_status, @result.error.message)
    end
  end

  require_auth action: :new
  grant_access action: :new, roles: [ :superadmin ]
  # @route GET /myaccount/blogtags/new (myaccount_blogtag_new)
  def new
    @result = MyaccountBlogtags::New::Service.call
    @blogtag = @result.data[:blogtag]
  end

  require_auth action: :edit
  grant_access action: :edit, roles: [ :superadmin ]
  # @route GET /myaccount/blogtags/:slug/edit
  def edit
    @result = MyaccountBlogtags::Edit::Service.call(slug: params[:slug])

    if @result.success?
      @blogtag = @result.data[:blogtag]
    else
      render_error_page(@result.error.http_status, @result.error.message)
    end
  end

  require_auth action: :create
  grant_access action: :create, roles: [ :superadmin ]
  # @route tag /myaccount/blogtags (myaccount_blogtag)
  def create
    @result = MyaccountBlogtags::Create::Service.call(attributes: blogtag_params)
    @blogtag = @result.data[:blogtag]

    if @result.success?
      redirect_to myaccount_blogtag_list_path, notice: "Blogtag was successfully created."
    else
      render :new, status: :unprocessable_content
    end
  end

  require_auth action: :update
  grant_access action: :update, roles: [ :superadmin ]
  # @route PUT /myaccount/blogtags/:slug
  def update
    @result = MyaccountBlogtags::Update::Service.call(
      slug: params[:slug],
      attributes: blogtag_params
    )
    @blogtag = @result.data&.[](:blogtag)

    if @result.success?
      redirect_to myaccount_blogtag_list_path, notice: "Blogtag was successfully updated."
    elsif @result.error&.http_status == :not_found
      render_error_page(:not_found, @result.error.message)
    else
      render :edit, status: :unprocessable_content
    end
  end

  require_auth action: :destroy
  grant_access action: :destroy, roles: [ :superadmin ]
  # @route DELETE /myaccount/blogtags/:slug
  def destroy
    @result = MyaccountBlogtags::Destroy::Service.call(slug: params[:slug])

    if @result.success?
      redirect_to myaccount_path, notice: "Blogtag was successfully deleted."
    else
      render_error_page(@result.error.http_status, @result.error.message)
    end
  end

  private

  def blogtag_params
    params.require(:blogtag).permit(:slug, :name).to_h
  end
end
