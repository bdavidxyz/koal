class ApplicationController < ActionController::Base
  include Rabarber::Authorization

  before_action :set_current_request_details
  before_action :set_current_session
  before_action :authenticate

  def find_bot
    return unless params[:hp] == "1"
    head :ok
  end

  # Required by Rabarber
  def current_user
    Current.user
  end

  private

    def when_unauthorized
      head :not_found # pretend the page doesn't exist
    end
    def authenticate
      if session_record = Session.find_by_id(cookies.signed[:session_token])
        Current.session = session_record
      else
        redirect_to sign_in_path
      end
    end
    def set_current_session
      if session_record = Session.find_by_id(cookies.signed[:session_token])
        Current.session = session_record
      end
    end

    def set_current_request_details
      Current.user_agent = request.user_agent
      Current.ip_address = request.ip
    end
end
