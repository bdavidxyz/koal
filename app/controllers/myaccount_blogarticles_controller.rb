class MyaccountBlogarticlesController < ApplicationController
  include Pagy::Backend

  require_auth action: :index
  grant_access action: :index, roles: [ :superadmin ]
  # @route GET /myaccount/blogarticles (myaccount_blogarticle)
  def index
    sort = {}
    if params[:sort] && params[:direction]
      sort[params[:sort]] = params[:direction]
    else
      sort[:updated_at] = "desc"
    end
    scope = BlogArticle.order(sort)
    blogarticles = !!q ? Fuzzy::Search.new(scope, BlogArticle, q).run : scope
    begin
      @pagy, @blogarticles = pagy(blogarticles, limit: 10)
    rescue Pagy::OverflowError
      params[:page] = 1
      retry
    end
  end

  require_auth action: :show
  grant_access action: :show, roles: [ :superadmin ]
  # @route GET /myaccount/blogarticles/:slug
  def show
    @blogarticle = retrieve_blogarticle
  end

  require_auth action: :new
  grant_access action: :new, roles: [ :superadmin ]
  # @route GET /myaccount/blogarticles/new (myaccount_blogarticle_new)
  def new
    @blogarticle = BlogArticle.new
  end

  require_auth action: :edit
  grant_access action: :edit, roles: [ :superadmin ]
  # @route GET /myaccount/blogarticles/:slug/edit
  def edit
    @blogarticle = retrieve_blogarticle
  end

  require_auth action: :create
  grant_access action: :create, roles: [ :superadmin ]
  # @route POST /myaccount/blogarticles (myaccount_blogarticle)
  def create
    @blogarticle = BlogArticle.new(blogarticle_params)
    if @blogarticle.save
      redirect_to myaccount_blogarticle_list_path, notice: "BlogArticle was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  require_auth action: :update
  grant_access action: :update, roles: [ :superadmin ]
  # @route PUT /myaccount/blogarticles/:slug
  def update
    @blogarticle = retrieve_blogarticle
    if @blogarticle.update(blogarticle_params)
      redirect_to myaccount_blogarticle_list_path, notice: "BlogArticle was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  require_auth action: :destroy
  grant_access action: :destroy, roles: [ :superadmin ]
  # @route DELETE /myaccount/blogarticles/:slug
  def destroy
    blogarticle = retrieve_blogarticle
    blogarticle.destroy
    redirect_to myaccount_path, notice: "BlogArticle was successfully deleted."
  end

  private

  def retrieve_blogarticle
    BlogArticle.find_by(slug: params[:slug]) or not_found
  end

  def blogarticle_params
    params.require(:blogarticle).permit(:kontent, :title)
  end
end 