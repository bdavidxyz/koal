module MyaccountUsers::New
  class Service < Servus::Base
    def call
      success(user: User.new)
    end
  end
end
