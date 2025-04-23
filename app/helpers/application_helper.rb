module ApplicationHelper
  include Rabarber::Helpers

  def current_user
    Current.user
  end
end
