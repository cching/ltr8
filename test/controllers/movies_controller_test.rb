require 'test_helper'

class MoviesControllerTest < ActionController::TestCase
	test "ajax request to refresh_now_playing should return success" do
		xhr :get, :refresh_now_playing, index: 1
		assert_response :success
	end
end
