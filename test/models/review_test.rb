require "test_helper"

class ReviewTest < ActiveSupport::TestCase
  def review
    @review ||= Review.new
  end

  def test_valid
    assert review.valid?
  end
end
