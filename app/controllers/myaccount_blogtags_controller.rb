class MyaccountBlogtagsController < ApplicationController
  include Pagy::Method

  require_auth action: :index
  grant_access action: :index, roles: [ :superadmin ]
  # @route GET /myaccount/blogtags (myaccount_blogtag)
  def index
    @result = MyaccountBlogtags::Index::Service.call(
      sort: sanitize_sort_param,
      direction: sanitize_direction_param,
      query: q
    )

    @result.data[:pagy], @result.data[:blogtags] = pagy(:offset, @result.data[:blogtags], limit: 10)
  end

  require_auth action: :show
  grant_access action: :show, roles: [ :superadmin ]
  # @route GET /myaccount/blogtags/:slug
  def show
    run_service(MyaccountBlogtags::Show::Service, slug: params[:slug])
  end

  require_auth action: :new
  grant_access action: :new, roles: [ :superadmin ]
  # @route GET /myaccount/blogtags/new (myaccount_blogtag_new)
  def new
    run_service(MyaccountBlogtags::New::Service, nil)
  end

  require_auth action: :edit
  grant_access action: :edit, roles: [ :superadmin ]
  # @route GET /myaccount/blogtags/:slug/edit
  def edit
    run_service(MyaccountBlogtags::Edit::Service, slug: params[:slug])
  end

  require_auth action: :create
  grant_access action: :create, roles: [ :superadmin ]
  # @route tag /myaccount/blogtags (myaccount_blogtag)
  def create
    @result = MyaccountBlogtags::Create::Service.call(attributes: blogtag_params)

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

    if @result.success?
      redirect_to myaccount_blogtag_list_path, notice: "Blogtag was successfully updated."
    elsif @result.error&.http_status == :not_found
      render_service_error(@result.error)
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
      render_service_error(@result.error)
    end
  end

  private

  def blogtag_params
    params.require(:blogtag).permit(:slug, :name).to_h
  end

  def sanitize_sort_param
    params[:sort].to_s.strip.presence
  end

  def sanitize_direction_param
    params[:direction].to_s.strip.presence
  end
end
