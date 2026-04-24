module MyaccountBlogtags::Destroy
  class Service < Servus::Base
    def initialize(slug:)
      @slug = slug
    end

    def call
      blogtag = Blogtag.find_by(slug: @slug)
      return failure("Blogtag not found", type: NotFoundError) unless blogtag

      return failure("Blogtag could not be deleted", data: { blogtag: blogtag }) unless destroy(blogtag)

      success(blogtag: blogtag)
    end

    private
      def destroy(blogtag)
        blogtag.destroy
        blogtag.destroyed?
      end
  end
end
