class MyaccountUsersController < ApplicationController
  include Pagy::Backend

  require_auth

  grant_access action: :index, roles: [ :superadmin ]
  # @route GET /myaccount/users (myaccount_user)
  def index
    sort = {}
    if params[:sort] && params[:direction]
      sort[params[:sort]] = params[:direction]
    else
      sort[:updated_at] = "desc"
    end
    scope = User.order(sort)
    users = !!q ? Fuzzy::Search.new(scope, User, q).run : scope
    @pagy, @users = pagy(users, limit: 10)
  end

  grant_access action: :show, roles: [ :superadmin ]
  # @route GET /myaccount/users/:slug
  def show
    @user = retrieve_user
  end

  grant_access action: :new, roles: [ :superadmin ]
  # @route GET /myaccount/users/new (myaccount_user_new)
  def new
    @user = User.new
  end

  grant_access action: :edit, roles: [ :superadmin ]
  # @route GET /myaccount/users/:slug/edit
  def edit
    @user = retrieve_user
  end

  grant_access action: :create, roles: [ :superadmin ]
  # @route POST /myaccount/users (myaccount_user)
  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to myaccount_user_list_path, notice: "User was successfully created."
    else
      render :new, status: :unprocessable_content
    end
  end

  grant_access action: :update, roles: [ :superadmin ]
  # @route PUT /myaccount/users/:slug
  def update
    @user = retrieve_user
    if @user.update(user_params)
      redirect_to myaccount_user_list_path, notice: "User was successfully updated."
    else
      render :edit, status: :unprocessable_content
    end
  end

  grant_access action: :destroy, roles: [ :superadmin ]
  # @route DELETE /myaccount/users/:slug
  def destroy
    user = retrieve_user
    user.destroy
    redirect_to myaccount_path, notice: "User was successfully deleted."
  end

  private

  def retrieve_user
    User.find_by(slug: params[:slug]) or not_found
  end

  def user_params
    params.require(:user).permit(:email, :name, :verified, :password, :slug)
  end
end
