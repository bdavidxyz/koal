class MyaccountController < ApplicationController

  require_auth action: :index
  grant_access action: :index, roles: [ :member ]
  # @route GET /myaccount (myaccount)
  def index
  end

  require_auth action: :sessions
  grant_access action: :sessions, roles: [ :member ]
  # @route GET /myaccount/sessions (myaccount_sessions)
  def sessions
    @sessions = Current.user.sessions.order(created_at: :desc)
  end

  require_auth action: :email
  grant_access action: :email, roles: [ :member ]
  # @route GET /myaccount/email (myaccount_email)
  def email
    render locals: {
      user: Current.user
    }
  end

  require_auth action: :password
  grant_access action: :password, roles: [ :member ]
  # @route GET /myaccount/password (myaccount_password)
  def password
    @user = Current.user
  end

  require_auth action: :profile
  grant_access action: :profile, roles: [ :member ]
  # @route GET /myaccount/profile (myaccount_profile)
  def profile
    render locals: {
      user: Current.user
    }
  end

  require_auth action: :billing
  grant_access action: :billing, roles: [ :member ]
  # @route GET /myaccount/billing (myaccount_billing)
  def billing
  end

  require_auth action: :danger 
  grant_access action: :danger, roles: [ :member ]
  # @route GET /myaccount/danger (myaccount_danger)
  def danger
  end

  require_auth action: :destroy_account
  grant_access action: :destroy_account, roles: [ :member ]
  # @route DELETE /myaccount/destroy (myaccount_destroy)
  def destroy_account
    user = Current.user
    Current.session.destroy
    user.destroy
    redirect_to root_path, notice: "Your account has been deleted."
  end
end
