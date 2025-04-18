class MyaccountController < ApplicationController
  def index
    u = Current.user
    sessions = u.sessions
    session = Current.session
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
end
