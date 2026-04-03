class SortDropdownComponent < ViewComponent::Base
  def initialize(column:, label:, query_params:, up_target: ".table-scroll")
    @column = column
    @label = label
    @query_params = query_params
    @up_target = up_target
  end

  def sorted_asc?
    @query_params["sort"] == @column && @query_params["direction"] == "asc"
  end

  def sorted_desc?
    @query_params["sort"] == @column && @query_params["direction"] == "desc"
  end

  def asc_href
    build_direction_href("asc")
  end

  def desc_href
    build_direction_href("desc")
  end

  def reset_href
    query_copy = @query_params.map { |k, v| [ k, v ] }.to_h
    query_copy.delete("sort")
    query_copy.delete("direction")
    "?#{query_copy.map { |k, v| "#{k}=#{v}" }.join("&")}"
  end

  private

  def build_direction_href(direction)
    query_copy = @query_params.map { |k, v| [ k, v ] }.to_h
    query_copy["sort"] = @column
    query_copy["direction"] = direction
    "?#{query_copy.map { |k, v| "#{k}=#{v}" }.join("&")}"
  end
end
