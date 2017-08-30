require 'test_helper'

class MovieTest < ActiveSupport::TestCase
  test "(Movie.define) movies with a valid Tmdb ID should return a valid response" do
  	5.times do |i|
  		movie_id = rand_int

  		begin
  			api_call = Tmdb::Movie.detail(movie_id).nil?
  		rescue
  			if !api_call
  				api_call = true
          # set nil? as true if no resources for movie_id
  			end
  			# rescue if resource is not found
  		end

  		assert_equal api_call, Movie.define("movie", "detail", movie_id).nil?
  		# compare orignal API call to dynamic method call
  	end
  end

  test "(Movie.define) collection methods (popular, top rated, etc) should return an array" do
  		assert_equal Movie.define("movie", "popular").results.class, Array
  end

  test "(Movie.define) image methods (backdrops, posters) with a valid Tmdb ID should return an array" do
  	5.times do |i|
  		movie_id = rand_int
  		collection = Movie.define("movie", "backdrops", movie_id)

  		if !collection.nil?
  			assert_equal collection.class, Array
  		end
  	end
  end

  test "(Movie.define) Discover method with hash params should return arrray" do
    alpha_by_title = Movie.define("discover", "movie", {:sort_by => "title.desc"}).results

    assert_equal alpha_by_title.class, Array
  end

  test "(Movie.define) collection methods (popular, top rated) with an unnecessary Tmdb ID should return nil" do
  	movie_id = rand_int
  	collection = Movie.define("movie", "popular", movie_id)

  	assert_nil collection
  end

  test "(Movie.image) movies with a valid ID that have backdrops and posters should have a valid URL" do
  	5.times do |i|
  		movie_id = rand_int
  		response = Movie.image("backdrops", movie_id, "original")

  		if !response.nil?
  			uri = URI(response)
  			http_check = Net::HTTP.new uri.host
			  http_response = http_check.request_head uri.path

			  request = http_response.code.to_i == 200
  		else
  			request = false
  		end

  		assert_equal !response.nil?, request
  	end
  end

  def rand_int
    rand(1..10000)
    # assign random Tmdb ID
  end
end
