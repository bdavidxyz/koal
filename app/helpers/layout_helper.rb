module LayoutHelper
  def show_layout_navigation?
    !(%w[sessions registrations].include?(controller_name) && action_name == "new")
  end
end
