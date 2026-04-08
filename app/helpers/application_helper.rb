module ApplicationHelper
  include Pagy::Frontend
  include Rabarber::Helpers
  include CurrentRouteHelper

  def current_user
    Current.user || User.new
  end
  def current_session
    Current.session
  end
end
