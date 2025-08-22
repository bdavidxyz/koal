module ReusableController
  extend ActiveSupport::Concern

  def find_bot
    return unless params[:hp] == "1"
    head :ok
  end

  # Required by Rabarber
  def current_user
    helpers.current_user
  end

  def not_found
    raise ActionController::RoutingError.new("Not Found")
  end

  def q
    params[:q]
  end

  def set_current_request_details
    Current.user_agent = request.user_agent
    Current.ip_address = request.ip
  end
end
