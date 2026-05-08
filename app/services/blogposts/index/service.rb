module Blogposts::Index
  class Service < Servus::Base
    def initialize(sort:, direction:, query:)
      @sort = sort
      @direction = direction
      @query = query
    end

    def call
      sort_params = build_sort_params
      scope = Blogpost.includes(:blogtags).where("published_at IS NOT NULL AND published_at <= ?", Time.current).order(sort_params)
      blogposts = Fuzzy::Search.call(scope: scope, query: @query).data[:results]

      success(blogposts: blogposts)
    rescue StandardError
      failure(
        "Unable to load blogposts",
        type: BadRequestError
      )
    end

    private
      def build_sort_params
        if @sort && @direction
          { @sort => @direction }
        else
          { published_at: "desc" }
        end
      end
  end
end
