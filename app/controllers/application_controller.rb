class ApplicationController < ActionController::Base
  include PaginableController
  include ReusableController
  include AuthenticableController

  # Session callbacks
  before_action :set_current_request_details
  before_action :set_current_session
  before_action :check_authentication_requirement

  # include after callbacks, see https://github.com/enjaku4/rabarber/issues/74
  include Rabarber::Authorization
  # https://github.com/brownboxdev/rabarber?tab=readme-ov-file#authorization-rules
  with_authorization
end
