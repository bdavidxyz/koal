module MyaccountBlogtags::Create
  class Service < Servus::Base
    def initialize(attributes:)
      @attributes = attributes
    end

    def call
      blogtag = Blogtag.new(@attributes)
      return failure("Blogtag could not be created", data: { blogtag: blogtag }) unless blogtag.save

      success(blogtag: blogtag)
    end
  end
end
