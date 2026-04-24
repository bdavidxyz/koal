module MyaccountBlogposts::Index
  class Service < Servus::Base
    SORT_COLUMNS = %w[id title slug published_at created_at updated_at].freeze
    SORT_DIRECTIONS = %w[asc desc].freeze
    DEFAULT_SORT_COLUMN = "updated_at"
    DEFAULT_SORT_DIRECTION = "desc"

    def initialize(sort:, direction:, query:)
      @sort = sort
      @direction = direction
      @query = query
    end

    def call
      success(blogposts: filtered_blogposts)
    end

    private
      def filtered_blogposts
        scope = Blogpost.order(sort_clause)
        return scope if normalized_query.blank?

        Fuzzy::Search.call(scope: scope, query: normalized_query).data[:results]
      end

      def sort_clause
        { sort_column => sort_direction }
      end

      def sort_column
        SORT_COLUMNS.include?(@sort) ? @sort : DEFAULT_SORT_COLUMN
      end

      def sort_direction
        SORT_DIRECTIONS.include?(@direction) ? @direction : DEFAULT_SORT_DIRECTION
      end

      def normalized_query
        @normalized_query ||= @query.to_s.strip
      end
  end
end
