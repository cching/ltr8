class MoviesController < ApplicationController
  before_action :set_movie, only: [:show]
  before_action :set_now_playing, only: [:home, :refresh_now_playing]
  before_action :set_page, only: [:search]

  def home
    @now_playing = @now_playing[0]
    @image = Movie.image("backdrops", @now_playing.id, "w1280")
    # load initial now playing movie on home page
  end

  def home_assets
    # use to render movie categories and movies after page load to redue initial page loading times
    respond_to :js
  end

  def refresh_now_playing
    # udpates the now playing backdrop and title on the home page parallax
    index = params[:index].to_i
    # enforce params as int to sanitize
    @now_playing = @now_playing[index]
    until !Movie.image("backdrops", @now_playing.id, "w1280").nil?
      @now_playing = Movie.define("movie", "now_playing").results[index +=1]
    end
    # get next sequence in case movie doesn't have backdrop
    @image = Movie.image("backdrops", @now_playing.id, "w1280")
  end

  def search
    form_params = ["original_title_sort", "primary_release_date_sort"]
    # Tmdb API does not allow mixed queries between titles and release date/title name/date, eg a title can't be inputted and then sorted remotely
    # two separate Tmdb methods must be used (Tmdb::Discover & Tmdb::Search)

    if Movie.params_exist(params[:title])
      # sort by title if params exist
      @movies = Movie.define("search", "movie", {:page => @page, :language => "en-US", :region => "US"}, params[:title])
      # no sql query, params only sent to Tmdb API, no risk of local injection from user input
    elsif Movie.params_exist(params[:movie]) || form_params.map { |x| Movie.params_exist(params[x.to_sym]) }.any?
      # sort by genre or release date/title name if params exist
      form_params.map{ |x| @sort = params[x.to_sym] unless params[x.to_sym].empty? }
      params_hash = {:sort_by => @sort, :with_genres => "#{params[:movie][:genre_id].to_i unless params[:movie].nil?}", :language => "en-US", :region => "US", :page => @page}
      @movies = Movie.define("discover", "movie", params_hash)
    elsif Movie.params_exist(params[:category])
      # sorting for category links
      @category = params[:category]
      @movies = Movie.define("movie", @category, {:page => @page})
    else
      # default to top rated if no search terms given
      @category = "top_rated"
      @movies = Movie.define("movie", @category, {:page => @page})
    end
  end

  def show
      @backdrop = Movie.image("backdrops", @movie.id, "w1280")
      @cast = Movie.define("movie", "cast", @movie.id)
      @directors = Movie.define("movie", "director", @movie.id)
      @comments = Review.where(:movie_id => @movie.id).where.not(content: "").order("created_at DESC")
      @rating = Review.rating(@movie.id)
  end

  private
    def set_movie
      @movie = Movie.define("movie", "detail", params[:id].to_i)
      if @movie.nil?
        redirect_to movie_path(71481)
      end
    end

    def set_now_playing
      @now_playing = Movie.define("movie", "now_playing").results
    end

    def set_page
      if params[:direction] == "next"
        @page = params[:page].to_i 
        @page += 1
      elsif params[:direction] == "prev"
        @page = params[:page].to_i 
        @page -= 1 
      end
      # define page number and page direction for pagination
      @page ||= 1
      # if no page direction, start at page 1
    end
end
