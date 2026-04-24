module MyaccountBlogposts::Create
  class Service < Servus::Base
    def initialize(attributes:, blogtag_ids:)
      @attributes = attributes
      @blogtag_ids = blogtag_ids
    end

    def call
      blogpost = Blogpost.new(@attributes)

      return failure("Blogpost could not be created", data: { blogpost: blogpost }) unless persist(blogpost)

      success(blogpost: blogpost)
    end

    private
      def persist(blogpost)
        Blogpost.transaction do
          return false unless blogpost.save

          blogpost.blogtag_ids = normalized_blogtag_ids
        end

        true
      end

      def normalized_blogtag_ids
        Array(@blogtag_ids).reject(&:blank?)
      end
  end
end
