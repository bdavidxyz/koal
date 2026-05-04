class ApplicationController < ActionController::Base
  include PaginableController
  include ReusableController
  include AuthenticableController
  include RecordableController
  include ErrorableController

  # Session callbacks
  before_action :set_current_request_details
  before_action :set_current_session
  before_action :set_error_reporter_context
  before_action :check_authentication_requirement

  # include after callbacks, see https://github.com/enjaku4/rabarber/issues/74
  include Rabarber::Authorization
  # https://github.com/brownboxdev/rabarber?tab=readme-ov-file#authorization-rules
  with_authorization

  def when_unauthorized
    head :not_found # Custom behavior to hide existence of protected resources
  end

  private

  def set_error_reporter_context
    Rails.error.set_context(
      request_id: request.request_id,
      request_method: request.request_method,
      request_path: request.fullpath,
      user_id: Current.user&.id
    )
  end
end
