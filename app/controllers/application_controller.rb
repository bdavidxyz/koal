class ApplicationController < ActionController::Base
  class_attribute :authentication_requirements, default: {}
  # Session callbacks
  before_action :set_current_request_details
  before_action :set_current_session
  before_action :check_authentication_requirement
  # include after callbacks, see https://github.com/enjaku4/rabarber/issues/74
  include Rabarber::Authorization
  # https://github.com/brownboxdev/rabarber?tab=readme-ov-file#authorization-rules
  with_authorization

  # Handle Pagy overflow errors by redirecting to the last page
  rescue_from Pagy::OverflowError, with: :redirect_to_last_page


  def self.no_auth_for(action)
    grant_access action: action
  end

  def self.require_auth(action: nil)
    if action
      self.authentication_requirements = authentication_requirements.merge(action.to_sym => true)
    else
      before_action :ensure_authenticated!
    end
  end

  def find_bot
    return unless params[:hp] == "1"
    head :ok
  end

  # Redirect to the last valid page when a Pagy::OverflowError occurs
  # :nocov:
  def redirect_to_last_page(exception)
    redirect_to url_for(page: exception.pagy.last), notice: "Page ##{params[:page]} is overflowing. Showing page #{exception.pagy.last} instead."
  end
  # :nocov:

  # Required by Rabarber
  def current_user
    helpers.current_user
  end
  # Be homogeneous with current_user above
  def current_session
    helpers.current_session
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
  def ensure_authenticated!
    if not @session_record
      redirect_to sign_in_path
    end
  end
  private
    def check_authentication_requirement
      if self.class.authentication_requirements[action_name.to_sym]
        ensure_authenticated!
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
