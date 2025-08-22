class ApplicationController < ActionController::Base
  include PaginableController
  include AuthenticableController

  # Session callbacks
  before_action :set_current_request_details
  before_action :set_current_session
  before_action :check_authentication_requirement

  # include after callbacks, see https://github.com/enjaku4/rabarber/issues/74
  include Rabarber::Authorization
  # https://github.com/brownboxdev/rabarber?tab=readme-ov-file#authorization-rules
  with_authorization

  def find_bot
    return unless params[:hp] == "1"
    head :ok
  end

  # Required by Rabarber
  def current_user
    helpers.current_user
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

  def set_current_request_details
    Current.user_agent = request.user_agent
    Current.ip_address = request.ip
  end
end
