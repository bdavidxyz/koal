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
      @result.data[:pagy], @result.data[:roles] = pagy(:offset, @result.data[:roles], limit: 10)
    end
  end

  require_auth action: :show
  grant_access action: :show, roles: [ :superadmin ]
  # @route GET /myaccount/roles/:slug
  def show
    @result = MyaccountRoles::Show::Service.call(id: params[:id])

    if @result.failure?
      render_error_page(@result.error.http_status, @result.error.message)
    end
  end

  require_auth action: :new
  grant_access action: :new, roles: [ :superadmin ]
  # @route GET /myaccount/roles/new (myaccount_role_new)
  def new
    @result = MyaccountRoles::New::Service.call
  end

  require_auth action: :edit
  grant_access action: :edit, roles: [ :superadmin ]
  # @route GET /myaccount/roles/:slug/edit
  def edit
    @result = MyaccountRoles::Edit::Service.call(id: params[:id])

    if @result.failure?
      render_error_page(@result.error.http_status, @result.error.message)
    end
  end

  require_auth action: :create
  grant_access action: :create, roles: [ :superadmin ]
  # @route tag /myaccount/roles (myaccount_role)
  def create
    @result = MyaccountRoles::Create::Service.call(attributes: role_params)

    if @result.success?
      redirect_to myaccount_role_list_path, notice: "Role was successfully created."
    else
      render :new, status: :unprocessable_content
    end
  end

  require_auth action: :update
  grant_access action: :update, roles: [ :superadmin ]
  # @route PUT /myaccount/roles/:slug
  def update
    @result = MyaccountRoles::Update::Service.call(
      id: params[:id],
      attributes: role_params
    )

    if @result.success?
      redirect_to myaccount_role_list_path, notice: "Role was successfully updated."
    elsif @result.error&.http_status == :not_found
      render_error_page(:not_found, @result.error.message)
    else
      render :edit, status: :unprocessable_content
    end
  end

  require_auth action: :destroy
  grant_access action: :destroy, roles: [ :superadmin ]
  # @route DELETE /myaccount/roles/:slug
  def destroy
    @result = MyaccountRoles::Destroy::Service.call(id: params[:id])

    if @result.success?
      redirect_to myaccount_path, notice: "Role was successfully deleted."
    else
      render_error_page(@result.error.http_status, @result.error.message)
    end
  end

  private
    def role_params
      params.require(:rabarber_role).permit(:name).to_h
    end
end
