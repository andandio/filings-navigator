require 'test_helper'

class Api::FilingsControllerTest < ActionController::TestCase
  setup do
    @filer = Filer.create(name: 'Example Filer')
    @filing = Filing.create(tax_period_end_at: '2023-12-31', filer_id: @filer.id)
  end

  test "should get index with all filings" do
    get :index
    assert_response :success

    json_response = JSON.parse(response.body)
    assert_equal true, json_response['success']
    assert_equal '', json_response['message']
    assert_not_nil json_response['data']
    assert_equal 1, json_response['data'].size
  end

  test "should get index with filings filtered by resource_id" do
    get :index, params: { resource_id: @filing.id }
    assert_response :success

    json_response = JSON.parse(response.body)
    assert_equal true, json_response['success']
    assert_equal '', json_response['message']
    assert_not_nil json_response['data']
    assert_equal 1, json_response['data'].size
  end
end





