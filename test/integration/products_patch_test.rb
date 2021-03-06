require "test_helper"

class ProductsPatchTest < ActionDispatch::IntegrationTest

  def setup
    sign_in("ruby")
  end

  def teardown
    sign_out
  end

  test 'successful update' do
    patch "/products/#{products(:ruby).id}",
      { product: { name: "Red Ruby" } }.to_json,
      { Accept: Mime::JSON, 'Content-Type' => Mime::JSON.to_s }
    assert_equal 200, response.status
    assert_equal 'Red Ruby', products(:ruby).reload.name
  end

  test 'unsuccessful update' do
    patch "/products/#{products(:ruby).id}",
      { product: { name: "" } }.to_json,
      { Accept: Mime::JSON, 'Content-Type' => Mime::JSON.to_s }

    assert_equal 422, response.status
  end
end
