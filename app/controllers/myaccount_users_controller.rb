class MyaccountUsersController < ApplicationController
  include Rabarber::Authorization

  grant_access roles: :superadmin

  # @route GET /myaccount/users (myaccount_users)
  def index
  end

  # @route GET /myaccount/users/:id (myaccount_user)
  def show
  end

  # @route GET /myaccount/users/new (new_myaccount_user)
  def new
  end

  # @route GET /myaccount/users/:id/edit (edit_myaccount_user)
  def edit
  end

  # @route POST /myaccount/users (myaccount_users)
  def create
  end

  # @route PATCH /myaccount/users/:id (myaccount_user)
  # @route PUT /myaccount/users/:id (myaccount_user)
  def update
  end

  # @route DELETE /myaccount/users/:id (myaccount_user)
  def destroy
  end
end
