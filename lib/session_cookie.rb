class SessionCookie
  def initialize(cookies)
    @cookies = cookies
  end

  def value
    @cookies.signed[:session_token]
  end

  def value=(session_record_id)
    @cookies.signed.permanent[:session_token] = { value: session_record_id, httponly: true }
  end

  def delete
    @cookies.delete(:session_token)
  end
end
