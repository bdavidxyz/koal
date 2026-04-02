class LayoutFooterComponent < ViewComponent::Base
  def initialize(controller_name:, action_name:)
    @controller_name = controller_name
    @action_name = action_name
  end

  def render?
    !(%w[sessions registrations].include?(@controller_name) && @action_name == "new")
  end
end
