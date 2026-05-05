require "test_helper"

class SessionCookieTest < ActiveSupport::TestCase
  class MockCookies
    attr_reader :signed, :deleted_keys

    def initialize
      @signed = MockSigned.new
      @deleted_keys = []
    end

    def delete(key)
      @deleted_keys << key
    end
  end

  class MockSigned
    attr_reader :permanent, :values

    def initialize
      @permanent = MockPermanent.new(self)
      @values = {}
    end

    def [](key)
      @values[key]
    end

    def []=(key, value)
      @values[key] = value
    end
  end

  class MockPermanent
    attr_reader :values

    def initialize(signed)
      @signed = signed
      @values = {}
    end

    def []=(key, value)
      @values[key] = value
    end
  end

  test "reads value from signed cookies" do
    cookies = MockCookies.new
    cookies.signed.values[:session_token] = "abc"

    session_cookie = SessionCookie.new(cookies)
    assert_equal "abc", session_cookie.value
  end

  test "writes value to permanent signed cookies" do
    cookies = MockCookies.new
    session_cookie = SessionCookie.new(cookies)
    session_cookie.value = "123"

    assert_equal({ value: "123", httponly: true }, cookies.signed.permanent.values[:session_token])
  end

  test "deletes session token" do
    cookies = MockCookies.new
    session_cookie = SessionCookie.new(cookies)
    session_cookie.delete

    assert_includes cookies.deleted_keys, :session_token
  end
end
