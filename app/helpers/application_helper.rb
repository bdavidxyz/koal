module ApplicationHelper
  include Pagy::Frontend
  include Rabarber::Helpers
  include CurrentRouteHelper

  def current_user
    Current.user || User.new
  end
  def current_session
    Current.session
  end
  def build_href_to_sort(sort_by, query_params)
    direction = query_params["direction"]
    query_copy = query_params.map { |k, v| [ k, v ] }.to_h
    query_copy["sort"] = sort_by
    query_copy["direction"] = direction == "asc" ? "desc" : "asc"
    query_string = query_copy.map { |key, value| "#{key}=#{value}" }.join("&")
    query_string
  end

  def build_sort_direction_href(column, direction, query_params)
    query_copy = query_params.map { |k, v| [ k, v ] }.to_h
    query_copy["sort"] = column
    query_copy["direction"] = direction
    query_copy.map { |key, value| "#{key}=#{value}" }.join("&")
  end

  def build_sort_reset_href(query_params)
    query_copy = query_params.map { |k, v| [ k, v ] }.to_h
    query_copy.delete("sort")
    query_copy.delete("direction")
    query_copy.map { |key, value| "#{key}=#{value}" }.join("&")
  end
end
