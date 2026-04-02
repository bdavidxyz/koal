class LayoutFooterComponent < ViewComponent::Base
  def initialize(controller_name:, action_name:, request_path:)
    @controller_name = controller_name
    @action_name = action_name
    @request_path = request_path
  end

  def render?
    return false if @request_path.start_with?("/myaccount")

    !(%w[sessions registrations].include?(@controller_name) && @action_name == "new")
  end
end
