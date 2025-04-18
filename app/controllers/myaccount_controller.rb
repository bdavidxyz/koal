class MyaccountController < ApplicationController
  def index
    render locals: {
      email: Current.user.email,
      session: Current.session
    }
  end
end
