class MyaccountBlogtagsController < ApplicationController
  include Pagy::Backend

  require_auth action: :index
  grant_access action: :index, roles: [ :superadmin ]
  # @route GET /myaccount/blogtags (myaccount_blogtag)
  def index
    sort = {}
    if params[:sort] && params[:direction]
      sort[params[:sort]] = params[:direction]
    else
      sort[:updated_at] = "desc"
    end
    scope = Blogtag.order(sort)
    blogtags = !!q ? Fuzzy::Search.new(scope, Blogtag, q).run : scope
    @pagy, @blogtags = pagy(blogtags, limit: 10)
  end

  require_auth action: :show
  grant_access action: :show, roles: [ :superadmin ]
  # @route GET /myaccount/blogtags/:slug
  def show
    @blogtag = retrieve_blogtag
  end

  require_auth action: :new
  grant_access action: :new, roles: [ :superadmin ]
  # @route GET /myaccount/blogtags/new (myaccount_blogtag_new)
  def new
    @blogtag = Blogtag.new
  end

  require_auth action: :edit
  grant_access action: :edit, roles: [ :superadmin ]
  # @route GET /myaccount/blogtags/:slug/edit
  def edit
    @blogtag = retrieve_blogtag
  end

  require_auth action: :create
  grant_access action: :create, roles: [ :superadmin ]
  # @route tag /myaccount/blogtags (myaccount_blogtag)
  def create
    @blogtag = Blogtag.new(blogtag_params)
    if @blogtag.save
      redirect_to myaccount_blogtag_list_path, notice: "Blogtag was successfully created."
    else
      render :new, status: :unprocessable_content
    end
  end

  require_auth action: :update
  grant_access action: :update, roles: [ :superadmin ]
  # @route PUT /myaccount/blogtags/:slug
  def update
    @blogtag = retrieve_blogtag
    if @blogtag.update(blogtag_params)
      redirect_to myaccount_blogtag_list_path, notice: "Blogtag was successfully updated."
    else
      render :edit, status: :unprocessable_content
    end
  end

  require_auth action: :destroy
  grant_access action: :destroy, roles: [ :superadmin ]
  # @route DELETE /myaccount/blogtags/:slug
  def destroy
    blogtag = retrieve_blogtag
    blogtag.destroy
    redirect_to myaccount_path, notice: "Blogtag was successfully deleted."
  end

  private

  def retrieve_blogtag
    Blogtag.find_by(slug: params[:slug]) or not_found
  end

  def blogtag_params
    params.require(:blogtag).permit(:slug, :name)
  end
end
