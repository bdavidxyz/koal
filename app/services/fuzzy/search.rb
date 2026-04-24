module Fuzzy
  class Search < Servus::Base
    def initialize(scope:, query:)
      @scope = scope
      @query = query
    end

    def call
      success(results: filtered_scope)
    end

    private
      def filtered_scope
        return @scope.all if normalized_query.blank?

        @scope.where(query_template, *query_values)
      end

      def query_template
        search_attributes.map do |attribute|
          table_name = quoted_table_name
          column_name = quoted_column_name(attribute.name)
          "LOWER(CAST(#{table_name}.#{column_name} AS CHAR(256))) LIKE ?"
        end.join(" OR ")
      end

      def query_values
        [ "%#{normalized_query.downcase}%" ] * search_attributes.count
      end

      def search_attributes
        @scope.klass.searchable_attributes
      end

      def quoted_table_name
        ActiveRecord::Base.connection.quote_column_name(@scope.table_name)
      end

      def quoted_column_name(attribute)
        ActiveRecord::Base.connection.quote_column_name(attribute)
      end

      def normalized_query
        @normalized_query ||= @query.to_s.strip
      end
  end
end
