class ApplicationController < ActionController::Base
  # Session callbacks
  before_action :set_current_request_details
  before_action :set_current_session
  before_action :authenticate
  # include after callbacks, see https://github.com/enjaku4/rabarber/issues/74
  include Rabarber::Authorization

  def find_bot
    return unless params[:hp] == "1"
    head :ok
  end

  # Required by Rabarber
  def current_user
    Current.user
  end
  # Be homogeneous with current_user above
  def current_session
    Current.session
  end
  def when_unauthorized
    head :not_found # pretend the page doesn't exist
  end
  def not_found
    raise ActionController::RoutingError.new("Not Found")
  end
  def q
    params[:q]
  end

  private

    def authenticate
      if not @session_record
        redirect_to sign_in_path
      end
    end
    def set_current_session
      if @session_record = Session.find_by_id(cookies.signed[:session_token])
        Current.session = @session_record
      end
    end

    def set_current_request_details
      Current.user_agent = request.user_agent
      Current.ip_address = request.ip
    end
end
