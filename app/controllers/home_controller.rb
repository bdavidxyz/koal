class HomeController < ApplicationController
  skip_before_action :authenticate
  # @route GET /home/index (home_index)
  # @route GET / (root)
  def index
    # @user = User.first
  end
end
