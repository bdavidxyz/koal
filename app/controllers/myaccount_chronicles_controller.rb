class MyaccountChroniclesController < ApplicationController
  include Pagy::Backend

  require_auth action: :index
  grant_access action: :index, roles: [ :superadmin ]
  # @route GET /myaccount/chronicles (myaccount_chronicle)
  def index
    sort = {}
    if params[:sort] && params[:direction]
      sort[params[:sort]] = params[:direction]
    else
      sort[:updated_at] = "desc"
    end
    scope = Chronicle.order(sort)
    chronicles = !!q ? Fuzzy::Search.new(scope, Chronicle, q).run : scope
    begin
      @pagy, @chronicles = pagy(chronicles, limit: 10)
    rescue Pagy::OverflowError
      params[:page] = 1
      retry
    end
  end

  require_auth action: :show
  grant_access action: :show, roles: [ :superadmin ]
  # @route GET /myaccount/chronicles/:slug
  def show
    @chronicle = retrieve_chronicle
  end

  require_auth action: :new
  grant_access action: :new, roles: [ :superadmin ]
  # @route GET /myaccount/chronicles/new (myaccount_chronicle_new)
  def new
    @chronicle = Chronicle.new
  end

  require_auth action: :edit
  grant_access action: :edit, roles: [ :superadmin ]
  # @route GET /myaccount/chronicles/:slug/edit
  def edit
    @chronicle = retrieve_chronicle
  end

  require_auth action: :create
  grant_access action: :create, roles: [ :superadmin ]
  # @route POST /myaccount/chronicles (myaccount_chronicle)
  def create
    @chronicle = Chronicle.new(chronicle_params)
    if @chronicle.save
      redirect_to myaccount_chronicle_list_path, notice: "Chronicle was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  require_auth action: :update
  grant_access action: :update, roles: [ :superadmin ]
  # @route PUT /myaccount/chronicles/:slug
  def update
    @chronicle = retrieve_chronicle
    if @chronicle.update(chronicle_params)
      redirect_to myaccount_chronicle_list_path, notice: "Chronicle was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  require_auth action: :destroy
  grant_access action: :destroy, roles: [ :superadmin ]
  # @route DELETE /myaccount/chronicles/:slug
  def destroy
    chronicle = retrieve_chronicle
    chronicle.destroy
    redirect_to myaccount_path, notice: "Chronicle was successfully deleted."
  end

  private

  def retrieve_chronicle
    Chronicle.find_by(slug: params[:slug]) or not_found
  end

  def chronicle_params
    params.require(:chronicle).permit(:title, :kontent, :slug)
  end
end
