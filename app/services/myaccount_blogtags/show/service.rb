module MyaccountBlogtags::Show
  class Service < Servus::Base
    def initialize(slug:)
      @slug = slug
    end

    def call
      blogtag = Blogtag.find_by(slug: @slug)
      return failure("Blogtag not found", type: NotFoundError) unless blogtag

      success(blogtag: blogtag)
    end
  end
end
