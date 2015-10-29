require "test_helper"

class ProductsCreateTest < ActionDispatch::IntegrationTest

  def setup
    sign_in("ruby")
  end

  def teardown
    sign_out
  end

  test 'creates a new product' do
    post '/products',
      { product:
        { name: 'Emerald',
          price: 7.00,
          description: 'Green!',
          canPurchase: true }
      }.to_json,
      { Accept: Mime::JSON, 'Content-Type' => Mime::JSON.to_s }
    assert_equal 201, response.status
    assert_equal Mime::JSON, response.content_type
    emerald = json(response.body)[:product]
    assert_equal emerald[:price], "7.0"
  end

  test 'does not create without a name' do
    post '/products',
      { product:
        { name: nil,
          price: 7.00,
          description: 'Green!',
          canPurchase: true }
      }.to_json,
      { Accept: Mime::JSON, 'Content-Type' => Mime::JSON.to_s }
    assert_equal 422, response.status
    assert_equal Mime::JSON, response.content_type
  end
end
