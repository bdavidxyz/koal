module ApplicationHelper
  include Rabarber::Helpers

  def current_user
    Current.user
  end
  def current_session
    Current.session
  end
end
