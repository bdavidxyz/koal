require "test_helper"

class MyaccountChroniclesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = sign_in_as(users(:jane))
    @chronicle = chronicles(:first_chronicle)
  end

  test "should get index" do
    get myaccount_chronicle_list_url
    assert_response :success
  end

  test "should get new" do
    get myaccount_chronicle_new_url
    assert_response :success
  end

  test "should create chronicle" do
    assert_difference("Chronicle.count") do
      post myaccount_chronicle_create_url, params: { chronicle: { chapo: @chronicle.chapo, kontent: @chronicle.kontent, published_at: @chronicle.published_at, slug: "new_slug", title: @chronicle.title } }
    end

    assert_redirected_to myaccount_chronicle_list_url
  end

  test "should show chronicle" do
    get myaccount_chronicle_show_url(slug: @chronicle.slug)
    assert_response :success
  end

  test "should get edit" do
    get myaccount_chronicle_edit_url(slug: @chronicle.slug)
    assert_response :success
  end

  test "should update chronicle" do
    put myaccount_chronicle_update_url(slug: @chronicle.slug), params: { chronicle: { chapo: @chronicle.chapo, kontent: @chronicle.kontent, published_at: @chronicle.published_at, slug: @chronicle.slug, title: @chronicle.title } }
    assert_redirected_to myaccount_chronicle_list_url
  end

  test "should destroy chronicle" do
    assert_difference("Chronicle.count", -1) do
      delete myaccount_chronicle_destroy_url(slug: @chronicle.slug)
    end

    assert_redirected_to myaccount_url
  end
end