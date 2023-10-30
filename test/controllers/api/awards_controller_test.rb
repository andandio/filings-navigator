class Api::AwardsControllerTest < ActionController::TestCase
  setup do
    @filer = Filer.create(name: 'Example Filer')
    @filing = Filing.create(tax_period_end_at: '2023-12-31', filer_id: @filer.id)
    @award = Award.create(cash_award: 1000.00, purpose: 'Research grant', filing: @filing, grantmaker: @filer)
  end

  test "should get index with all awards" do
    get :index
    assert_response :success

    json_response = JSON.parse(response.body)
    assert_equal true, json_response['success']
    assert_equal '', json_response['message']
    assert_not_nil json_response['data']
    assert_equal 1, json_response['data'].size
  end

  test "should get index with awards filtered by year and filer" do
    get :index, params: { year: '2023-12-31', filer_id: @filer.id }
    assert_response :success

    json_response = JSON.parse(response.body)
    assert_equal true, json_response['success']
    assert_equal '', json_response['message']
    assert_not_nil json_response['data']
    assert_equal 1, json_response['data'].size
  end
end