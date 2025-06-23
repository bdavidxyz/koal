class MasqueradesController < ApplicationController
  before_action :set_user

  require_auth action: :create
  grant_access action: :create, roles: [ :superadmin ]
  def create
    session_record = @user.sessions.create!
    cookies.signed.permanent[:session_token] = { value: session_record.id, httponly: true }

    redirect_to myaccount_path, notice: "Signed in successfully"
  end

  private
    def set_user
      @user = User.find(params[:user_id])
    end
end
