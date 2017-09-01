require 'test_helper'

class UserTest < ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods

  setup do
    @user = User.new(email: "cching@berkeley.edu")
  end
  
  test "valid user parameters" do
  	assert @user.valid?
  end

  test "user with nil email" do
  	@user.email = nil
  	refute @user.valid?
  	assert_not_nil @user.errors[:email]
  end

  test "user with invalid email structure" do
  	@user.email = "cching"
  	refute @user.valid?
  	assert_not_nil @user.errors[:email]
  end

  test "validate uniqueness of email" do
    user = create(:user, email: "cching@berkeley.edu")
    assert_not_nil build(:user, email: "cching@berkeley.edu").errors[:email]
  end
end
 