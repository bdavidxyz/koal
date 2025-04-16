class HomeController < ApplicationController
  skip_before_action :authenticate
  def index
    @user = User.first
  end
end
