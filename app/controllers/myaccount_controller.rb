class MyaccountController < ApplicationController

  grant_access roles: :member, action: :index
  # @route GET /myaccount (myaccount)
  def index
  end

  grant_access roles: :member, action: :sessions
  # @route GET /myaccount/sessions (myaccount_sessions)
  def sessions
    render locals: {
      sessions: Current.user.sessions.order(created_at: :desc)
    }
  end

  grant_access roles: :member, action: :email
  # @route GET /myaccount/email (myaccount_email)
  def email
    render locals: {
      user: Current.user
    }
  end

  grant_access roles: :member, action: :password
  # @route GET /myaccount/password (myaccount_password)
  def password
    render locals: {
      user: Current.user
    }
  end

  grant_access roles: :member, action: :profile
  # @route GET /myaccount/profile (myaccount_profile)
  def profile
    render locals: {
      user: Current.user
    }
  end

  grant_access roles: :member, action: :billing
  # @route GET /myaccount/billing (myaccount_billing)
  def billing
  end

  grant_access roles: :member, action: :danger
  # @route GET /myaccount/danger (myaccount_danger)
  def danger
  end

  grant_access roles: :member, action: :destroy_account
  # @route DELETE /myaccount/destroy (myaccount_destroy)
  def destroy_account
    user = Current.user
    Current.session.destroy
    user.destroy
    redirect_to root_path, notice: "You account has been deleted."
  end
end
