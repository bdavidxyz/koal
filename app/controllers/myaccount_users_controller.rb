class MyaccountUsersController < ApplicationController

  grant_access roles: :superadmin, action: :index
  # @route GET /myaccount/users (myaccount_users)
  def index
    @users = User.all
  end

  grant_access roles: :superadmin, action: :show
  # @route GET /myaccount/users/:id (myaccount_user)
  def show
  end

  grant_access roles: :superadmin, action: :new
  # @route GET /myaccount/users/new (new_myaccount_user)
  def new
  end

  grant_access roles: :superadmin, action: :edit
  # @route GET /myaccount/users/:id/edit (edit_myaccount_user)
  def edit
    @user = User.find_by(slug: params[:id]) or not_found
  end

  grant_access roles: :superadmin, action: :create
  # @route POST /myaccount/users (myaccount_users)
  def create
  end

  grant_access roles: :superadmin, action: :update
  # @route PATCH /myaccount/users/:id (myaccount_user)
  # @route PUT /myaccount/users/:id (myaccount_user)
  def update
    @user = User.find_by(slug: params[:id]) or not_found
    if @user.update(user_params)
      redirect_to myaccount_users_path, notice: "User was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  grant_access roles: :superadmin, action: :destroy
  # @route DELETE /myaccount/users/:id (myaccount_user)
  def destroy
  end

  private
  def user_params
    params.require(:user).permit(:email, :verified)
  end
end
