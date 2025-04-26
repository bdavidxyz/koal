class MyaccountUsersController < ApplicationController
  include Pagy::Backend

  grant_access roles: :superadmin, action: :index
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
    begin
      @pagy, @users = pagy(users, limit: 10)
    rescue Pagy::OverflowError
      params[:page] = 1
      retry
    end
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
    user = retrieve_user
    user.destroy
    redirect_to myaccount_path, notice: "User was successfully deleted."
  end

  private
  def retrieve_user
    User.find_by(slug: params[:slug]) or not_found
  end
  def user_params
    params.require(:user).permit(:email, :name, :verified)
  end
end
