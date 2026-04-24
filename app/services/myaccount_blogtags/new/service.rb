module MyaccountBlogtags::New
  class Service < Servus::Base
    def call
      success(blogtag: Blogtag.new)
    end
  end
end
