class HomeController < ApplicationController
  skip_before_action :authenticate

  grant_access action: :index
  # @route GET /home/index (home_index)
  # @route GET / (root)
  def index
  end
end
