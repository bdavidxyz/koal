class HomeController < ApplicationController
  grant_access action: :index
  # @route GET /home/index (home_index)
  # @route GET / (root)
  def index
  end
end
