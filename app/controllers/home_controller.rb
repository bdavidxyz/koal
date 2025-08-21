class HomeController < ApplicationController
  skip_authorization

  # @route GET /home/index (home_index)
  # @route GET / (root)
  def index
  end
end
