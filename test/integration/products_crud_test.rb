require "test_helper"

class ProductsCrudTest < ActionDispatch::IntegrationTest
  setup { host! 'api.example.com' }

  test 'returns all products' do
    get '/products', {}, { Accept: Mime::JSON }
    assert_equal 200, response.status
    assert_equal Mime::JSON, response.content_type
    products = json(response.body)[:products]
    assert_equal "9.99", products.detect { |gem| gem[:name] == "Ruby" }[:price]
  end

  test 'returns product by id' do
    product = Product.find_by(name: "Ruby")
    get "/products/#{product.id}"
    assert_equal 200, response.status
    product = json(response.body)
    assert_equal "9.99", product[:price]
  end
end
