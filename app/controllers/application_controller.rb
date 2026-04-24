class ApplicationController < ActionController::Base
  include PaginableController
  include ReusableController
  include AuthenticableController
  include RecordableController

  # Session callbacks
  before_action :set_current_request_details
  before_action :set_current_session
  before_action :check_authentication_requirement

  # include after callbacks, see https://github.com/enjaku4/rabarber/issues/74
  include Rabarber::Authorization
  # https://github.com/brownboxdev/rabarber?tab=readme-ov-file#authorization-rules
  with_authorization

  def when_unauthorized
    head :not_found # Custom behavior to hide existence of protected resources
  end

  def run_controller(service_class, params = {})
    run_service(service_class, params)
    result = @result
    return result if result.blank? || performed? || result.failure?

    dispatch_controller_response(result.data)
    result
  end

  def render_service_error(error)
    return dispatch_controller_response(@result.data) if @result&.data&.respond_to?(:controller_method)

    super
  end

  private
    def dispatch_controller_response(data)
      return if data.blank? || !data.respond_to?(:controller_method)

      send(data.controller_method, *Array(data.controller_args))
    end

    def redirect_to_route(route_helper, route_params = {}, redirect_options = {})
      redirect_to public_send(route_helper, **route_params.to_h.symbolize_keys), **redirect_options.to_h.symbolize_keys
    end
end
