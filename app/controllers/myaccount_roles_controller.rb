class MyaccountRolesController < ApplicationController
  include Pagy::Method

  require_auth action: :index
  grant_access action: :index, roles: [ :superadmin ]
  # @route GET /myaccount/roles (myaccount_role)
  def index
    @result = MyaccountRoles::Index::Service.call(
      sort: params[:sort],
      direction: params[:direction],
      query: q
    )

    if @result.success?
      @pagy, @result.data[:roles] = pagy(:offset, @result.data[:roles], limit: 10) if @result.success?
    end
  end

  require_auth action: :show
  grant_access action: :show, roles: [ :superadmin ]
  # @route GET /myaccount/roles/:slug
  def show
    @result = MyaccountRoles::Show::Service.call(id: params[:id])
    if @result.success?
      respond_to do |format|
        format.html { render :show }
        format.json { render json: @result.data[:role] }
      end
    else
      render_error_page(@result.error.http_status, @result.error.message)
    end
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
