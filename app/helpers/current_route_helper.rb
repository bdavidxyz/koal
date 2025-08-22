module CurrentRouteHelper
  def current_named_route(the_request = nil)
    local_request = the_request
    if defined? (request)
      local_request = request
    end
    return nil unless local_request&.path

    path = local_request.path
    method = local_request.method_symbol

    # On récupère les paramètres reconnus (controller, action, etc.)
    recognized = Rails.application.routes.recognize_path(path, method: method)

    # On parcourt toutes les routes
    Rails.application.routes.routes.each do |route|
      # Filtrage de base : nommée et avec defaults correspondants
      next unless route.name
      next unless route.verb.match?(method.to_s.upcase) || route.verb == ""

      # Vérification si les defaults correspondent (controller, action, etc.)
      route_defaults = route.defaults.symbolize_keys
      recognized_compact = recognized.slice(*route_defaults.keys).symbolize_keys

      if route_defaults == recognized_compact
        return route.name.to_sym
      end
    end

    nil
  rescue ActionController::RoutingError => e
    Rails.logger.debug "RoutingError: #{e.message}"
    nil
  end
end
