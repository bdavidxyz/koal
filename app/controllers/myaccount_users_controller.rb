class MyaccountUsersController < ApplicationController
  include Rabarber::Authorization


  grant_access roles: :superadmin, action: :index
  # @route GET /myaccount/users (myaccount_users)
  def index
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
  end

  grant_access roles: :superadmin, action: :create
  # @route POST /myaccount/users (myaccount_users)
  def create
  end

  grant_access roles: :superadmin, action: :update
  # @route PATCH /myaccount/users/:id (myaccount_user)
  # @route PUT /myaccount/users/:id (myaccount_user)
  def update
  end

  grant_access roles: :superadmin, action: :destroy
  # @route DELETE /myaccount/users/:id (myaccount_user)
  def destroy
  end
end
