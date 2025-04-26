module ApplicationHelper
  include Pagy::Frontend
  include Rabarber::Helpers

  def current_user
    Current.user
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
end
