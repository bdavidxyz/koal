module RecordableController
  extend ActiveSupport::Concern

  included do
    after_action :track_page_view
  end

  private

  def track_page_view
    return if request.is_crawler? || current_user&.has_role?(:superadmin)
    return unless response.content_type&.start_with?("text/html")

    ahoy.track "$view", { controller: controller_name, action: action_name }
  end
end
