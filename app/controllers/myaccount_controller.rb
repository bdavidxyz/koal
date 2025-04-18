class MyaccountController < ApplicationController
  def index
    session = Current.session
    u = Current.user
    sessions = u.sessions
    render locals: {
      email: u.email,
      session: session,
      session_number: u.sessions.order(created_at: :desc)
    }
  end
  def sessions
    render locals: {
      sessions: Current.user.sessions.order(created_at: :desc)
    }
  end
  def password
    render locals: {
      user: Current.user
    }
  end
  def profile
    render locals: {
      user: Current.user
    }
  end
end
