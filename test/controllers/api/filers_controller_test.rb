require 'test_helper'

class Api::FilersControllerTest < ActionController::TestCase
  setup do
    @filer = Filer.create(name: 'Example Filer')
  end

  test "should get index" do
    get :index
    assert_response :success

    json_response = JSON.parse(response.body)
    assert_equal true, json_response['success']
    assert_equal '', json_response['message']
    assert_not_nil json_response['data']
    assert_equal 1, json_response['data'].size
  end

  test "should show filer" do
    get :show, params: { id: @filer.id }
    assert_response :success

    json_response = JSON.parse(response.body)
    assert_equal true, json_response['success']
    assert_equal '', json_response['message']
    assert_not_nil json_response['data']
    assert_equal @filer.id, json_response['data']['id']
  end
end





