class SuperadminConstraint
  def matches?(request)
    session = Session.find_by_id(SessionCookie.new(request.cookie_jar).value)
    res = false
    if session
      res = session&.user&.has_role?(:superadmin)
    end
    res
  end
end
