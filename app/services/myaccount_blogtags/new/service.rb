module MyaccountBlogtags
  module New
    class Service < Servus::Base
      def call
        success(blogtag: Blogtag.new)
      end
    end
  end
end
