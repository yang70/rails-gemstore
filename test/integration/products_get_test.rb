require "test_helper"

class ProductsGetTest < ActionDispatch::IntegrationTest

  def setup
    sign_in("ruby")
  end

  def teardown
    sign_out
  end

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
    ruby = json(response.body)[:product]
    assert_equal "9.99", ruby[:price]
  end
end
