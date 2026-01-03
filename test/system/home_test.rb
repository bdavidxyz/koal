# test/system/home_test.rb
require "application_system_test_case"

class HomeTest < ApplicationSystemTestCase
  test "visiting the homepage shows a heading" do
    visit root_path

    assert_selector "h1", text: /customers/
  end
end
