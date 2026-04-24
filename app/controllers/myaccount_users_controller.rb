class MyaccountUsersController < ApplicationController
  include Pagy::Method

  require_auth action: :index
  grant_access action: :index, roles: [ :superadmin ]
  # @route GET /myaccount/users (myaccount_user)
  def index
    @result = MyaccountUsers::Index::Service.call(
      sort: params[:sort],
      direction: params[:direction],
      query: q
    )

    @result.data[:pagy], @result.data[:users] = pagy(:offset, @result.data[:users], limit: 10)
  end

  require_auth action: :show
  grant_access action: :show, roles: [ :superadmin ]
  # @route GET /myaccount/users/:slug
  def show
    @result = MyaccountUsers::Show::Service.call(slug: params[:slug])

    if @result.failure?
      render_error_page(@result.error.http_status, @result.error.message)
    end
  end

  require_auth action: :new
  grant_access action: :new, roles: [ :superadmin ]
  # @route GET /myaccount/users/new (myaccount_user_new)
  def new
    @result = MyaccountUsers::New::Service.call
  end

  require_auth action: :edit
  grant_access action: :edit, roles: [ :superadmin ]
  # @route GET /myaccount/users/:slug/edit
  def edit
    @result = MyaccountUsers::Edit::Service.call(slug: params[:slug])

    if @result.failure?
      render_error_page(@result.error.http_status, @result.error.message)
    end
  end

  require_auth action: :create
  grant_access action: :create, roles: [ :superadmin ]
  # @route POST /myaccount/users (myaccount_user)
  def create
    @result = MyaccountUsers::Create::Service.call(
      attributes: user_params_without_roles,
      role_ids: params.dig(:user, :role_ids)
    )

    if @result.success?
      redirect_to myaccount_user_list_path, notice: "User was successfully created."
    else
      render :new, status: :unprocessable_content
    end
  end

  require_auth action: :update
  grant_access action: :update, roles: [ :superadmin ]
  # @route PUT /myaccount/users/:slug
  def update
    @result = MyaccountUsers::Update::Service.call(
      slug: params[:slug],
      attributes: user_params_without_roles,
      role_ids: params.dig(:user, :role_ids)
    )

    if @result.success?
      redirect_to myaccount_user_list_path, notice: "User was successfully updated."
    elsif @result.error&.http_status == :not_found
      render_error_page(:not_found, @result.error.message)
    else
      render :edit, status: :unprocessable_content
    end
  end

  require_auth action: :destroy
  grant_access action: :destroy, roles: [ :superadmin ]
  # @route DELETE /myaccount/users/:slug
  def destroy
    @result = MyaccountUsers::Destroy::Service.call(slug: params[:slug])

    if @result.success?
      redirect_to myaccount_path, notice: "User was successfully deleted."
    else
      render_error_page(@result.error.http_status, @result.error.message)
    end
  end

  private

  def user_params_without_roles
    params.require(:user).permit(:email, :name, :verified, :password, :slug).to_h
  end
end
