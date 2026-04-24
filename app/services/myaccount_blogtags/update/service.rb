module MyaccountBlogtags::Update
  class Service < Servus::Base
    def initialize(slug:, attributes:)
      @slug = slug
      @attributes = attributes
    end

    def call
      blogtag = Blogtag.find_by(slug: @slug)
      return failure("Blogtag not found", type: NotFoundError) unless blogtag

      return failure("Blogtag could not be updated", data: { blogtag: blogtag }) unless blogtag.update(@attributes)

      success(blogtag: blogtag)
    end
  end
end
