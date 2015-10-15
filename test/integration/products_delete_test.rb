require "test_helper"

class ProductsDeleteTest < ActionDispatch::IntegrationTest
  setup { host! 'api.example.com' }

  test 'deletes a product' do
    delete "/products/#{products(:ruby).id}"
    assert_equal 204, response.status
  end
end
