class ReviewsController < ApplicationController

  def create
    product = Product.find(review_params[:product_id])
    review = Review.create(product: product, stars: review_params[:stars], body: review_params[:body], author: review_params[:author])
    if review.save
      render json: review, status: 201, location: review
    else
      render json: review.errors, status: 422
    end
  end

  private

  def review_params
    params.require(:review).permit(:stars, :body, :author, :product_id)
  end
end
