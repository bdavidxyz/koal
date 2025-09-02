class SuperadminConstraint
  def matches?(request)
    session = Session.find_by_id(request.cookie_jar.signed[:session_token])
    res = false
    if session
      res = session&.user&.has_role?(:superadmin)
    end
    res
  end
end
