class ApplicationController < ActionController::Base
  ERROR_PAGE_STATUS_RANGE = 400..511

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

  protected

  def render_error_page(status_code, message)
    status_code = normalize_error_status_code(status_code)

    unless ERROR_PAGE_STATUS_RANGE.cover?(status_code)
      raise ArgumentError, "HTTP error code must be between 400 and 511"
    end

    render "shared/error_page",
      layout: false,
      status: status_code,
      locals: {
        status_code: status_code,
        status_label: Rack::Utils::HTTP_STATUS_CODES.fetch(status_code, "Unknown Error"),
        message: message.to_s
      }
  end

  def normalize_error_status_code(status_code)
    return Rack::Utils::SYMBOL_TO_STATUS_CODE.fetch(status_code) if status_code.is_a?(Symbol)

    Integer(status_code)
  rescue KeyError
    raise ArgumentError, "Unknown HTTP status symbol: #{status_code.inspect}"
  end
end
