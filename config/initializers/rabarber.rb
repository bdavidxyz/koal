Rabarber.configure do |config|
  config.audit_trail_enabled = true
  config.cache_enabled = true
  config.current_user_method = :current_user
  config.must_have_roles = false
end
