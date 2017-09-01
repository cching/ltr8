require 'test_helper'

class ReviewTest < ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods
  
  test "valid range of rating between 1 and 5" do
  	review = Review.new(rating: 6, movie_id: 550, user_id: 1)
  	refute review.valid?
  	assert_not_nil review.errors[:rating]
  end

  test "valid rating should be an integer" do
  	review = Review.new(rating: "6", movie_id: 550, user_id: 1)
  	refute review.valid?
  	assert_not_nil review.errors[:rating]
  end

  test "review with empty parameters" do
  	review = Review.new
  	assert !review.save
  end

  test "an email associated with a user can only rate one movie" do
  	user = build(:user)
  	review = create(:review, user_id: user.id)
  	assert_not_nil build(:review, user_id: user.id).errors[:user_id]
  end
end
