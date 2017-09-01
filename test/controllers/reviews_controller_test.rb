require 'test_helper'

class ReviewsControllerTest < ActionController::TestCase
  setup do
    @review = reviews(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:reviews)
  end

  test "should get new" do
    xhr :get, :create, {email: "cching@berkeley.edu", movie_id: 550}
    assert_response :success
  end

  test "create should respond with 200" do
    xhr :post, :create, { content: @review.content, movie_id: @review.movie_id, rating: @review.rating, user_id: @review.user_id }
    assert_response :success
  end

  test "should create review" do
    assert_difference('Review.count') do
      xhr :post, :create, { content: @review.content, movie_id: @review.movie_id, rating: @review.rating, user_id: @review.user_id }
    end
  end
end
