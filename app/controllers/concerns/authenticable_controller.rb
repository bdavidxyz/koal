module AuthenticableController
  extend ActiveSupport::Concern

  included do
    class_attribute :authentication_requirements, default: {}
  end

  class_methods do
    def require_auth(action: nil)
      self.authentication_requirements = authentication_requirements.merge(action.to_sym => true)
    end
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
end
