module MyaccountRoles::Index
  class Service < Servus::Base
    SORT_COLUMNS = %w[id name created_at updated_at].freeze
    SORT_DIRECTIONS = %w[asc desc].freeze
    DEFAULT_SORT_COLUMN = "updated_at"
    DEFAULT_SORT_DIRECTION = "desc"

    def initialize(sort:, direction:, query:)
      @sort = sort
      @direction = direction
      @query = query
    end

    def call
      success(roles: filtered_roles)
    end

    private
      def filtered_roles
        scope = Rabarber::Role.order(sort_clause)
        return scope if normalized_query.blank?

        # Rabarber::Role does not expose searchable_attributes, so keep the
        # search constrained to a case-insensitive name match.
        scope.where("LOWER(name) LIKE ?", "%#{normalized_query.downcase}%")
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
