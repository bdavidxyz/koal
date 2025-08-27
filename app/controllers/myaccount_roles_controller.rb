class MyaccountRolesController < ApplicationController
  include Pagy::Backend

  require_auth action: :index
  grant_access action: :index, roles: [ :superadmin ]
  # @route GET /myaccount/roles (myaccount_role)
  def index
    sort = {}
    if params[:sort] && params[:direction]
      sort[params[:sort]] = params[:direction]
    else
      sort[:updated_at] = "desc"
    end
    scope = Rabarber::Role.order(sort)
    # Rabarber::Role doesn't support searchable_attributes, so use simple search
    roles = if !!q && q.present?
      scope.where("LOWER(name) LIKE ?", "%#{q.downcase}%")
    else
      scope
    end
    @pagy, @roles = pagy(roles, limit: 10)
  end

  require_auth action: :show
  grant_access action: :show, roles: [ :superadmin ]
  # @route GET /myaccount/roles/:slug
  def show
    @role = retrieve_role
  end

  require_auth action: :new
  grant_access action: :new, roles: [ :superadmin ]
  # @route GET /myaccount/roles/new (myaccount_role_new)
  def new
    @role = Rabarber::Role.new
  end

  require_auth action: :edit
  grant_access action: :edit, roles: [ :superadmin ]
  # @route GET /myaccount/roles/:slug/edit
  def edit
    @role = retrieve_role
  end

  require_auth action: :create
  grant_access action: :create, roles: [ :superadmin ]
  # @route tag /myaccount/roles (myaccount_role)
  def create
    @role = Rabarber::Role.new(role_params)
    if @role.save
      redirect_to myaccount_role_list_path, notice: "Role was successfully created."
    else
      render :new, status: :unprocessable_content
    end
  end

  require_auth action: :update
  grant_access action: :update, roles: [ :superadmin ]
  # @route PUT /myaccount/roles/:slug
  def update
    @role = retrieve_role
    if @role.update(role_params)
      redirect_to myaccount_role_list_path, notice: "Role was successfully updated."
    else
      render :edit, status: :unprocessable_content
    end
  end

  require_auth action: :destroy
  grant_access action: :destroy, roles: [ :superadmin ]
  # @route DELETE /myaccount/roles/:slug
  def destroy
    role = retrieve_role
    role.destroy
    redirect_to myaccount_path, notice: "Role was successfully deleted."
  end

  private

  def retrieve_role
    Rabarber::Role.find_by(id: params[:id]) or not_found
  end

  def role_params
    params.require(:rabarber_role).permit(:name)
  end
end
