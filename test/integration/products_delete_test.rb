require "test_helper"

class ProductsDeleteTest < ActionDispatch::IntegrationTest

  def setup
    sign_in("ruby")
  end

  def teardown
    sign_out
  end

  test 'deletes a product' do
    delete "/products/#{products(:ruby).id}"
    assert_equal 204, response.status
  end
end
