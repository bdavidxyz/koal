module MyaccountBlogposts::Update
  class Service < Servus::Base
    def initialize(slug:, attributes:, blogtag_ids:)
      @slug = slug
      @attributes = attributes
      @blogtag_ids = blogtag_ids
    end

    def call
      @blogpost = Blogpost.find_by(slug: @slug)
      return failure("Blogpost not found", type: NotFoundError) unless @blogpost

      persisted = persist
      if persisted
        success(blogpost: @blogpost)
      else
        failure("Blogpost could not be updated", data: { blogpost: @blogpost })
      end
    end

    private
      def persist
        Blogpost.transaction do
          return false unless @blogpost.update(@attributes)

          @blogpost.blogtag_ids = normalized_blogtag_ids
        end

        true
      end

      def normalized_blogtag_ids
        Array(@blogtag_ids).reject(&:blank?)
      end
  end
end
