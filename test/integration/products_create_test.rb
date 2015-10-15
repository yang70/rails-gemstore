require "test_helper"

class ProductsCreateTest < ActionDispatch::IntegrationTest
  setup { host! 'api.example.com' }

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
    emerald = json(response.body)
    assert_equal api_product_url(emerald[:id]), response.location
    # curl -i -X POST -d 'product[name]=Emerald' http://api.rails-gemstore.dev/products
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
