class MyaccountUsersController < ApplicationController
  grant_access roles: :superadmin, action: :index
  # @route GET /myaccount/users (myaccount_user)
  def index
    @users = User.all
  end

  grant_access roles: :superadmin, action: :show
  # @route GET /myaccount/users/:slug
  def show
    @user = retrieve_user
  end

  grant_access roles: :superadmin, action: :new
  # @route GET /myaccount/users/new (myaccount_user_new)
  def new
  end

  grant_access roles: :superadmin, action: :edit
  # @route GET /myaccount/users/:slug/edit
  def edit
    @user = retrieve_user
  end

  grant_access roles: :superadmin, action: :create
  # @route POST /myaccount/users (myaccount_user)
  def create
  end

  grant_access roles: :superadmin, action: :update
  # @route PUT /myaccount/users/:slug
  def update
    @user = retrieve_user
    if @user.update(user_params)
      redirect_to myaccount_user_list_path, notice: "User was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  grant_access roles: :superadmin, action: :destroy
  # @route DELETE /myaccount/users/:slug
  def destroy
  end

  private
  def retrieve_user
    User.find_by(slug: params[:slug]) or not_found
  end
  def user_params
    params.require(:user).permit(:email, :verified)
  end
end
