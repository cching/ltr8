class MoviesController < ApplicationController
  before_action :set_movie, only: [:show]
  before_action :set_now_playing, only: [:home, :refresh_now_playing]

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
    respond_to :js
  end

  def search
    sort_by = ["title_sort", "release_date_sort"]
    if params[:title].present?
      @movies = Movie.define("search", "movie").results
    elsif params[:movie].present? || sort_by.map {|x| params[x.to_sym]}.any?
      sort_by.map{ |x| @sort ||= params[x.to_sym]}
      params_hash = {:sort_by => @sort, :with_genres => "#{params[:movie][:genre_id].to_i if !params[:movie].nil?}"}
      @movies = Movie.define("discover", "movie", params_hash)
    end
  end

  def show
  end

  private
    def set_movie
      @movie = Movie.find(params[:id])
    end

    def set_now_playing
      @now_playing = Movie.define("movie", "now_playing").results
    end
end
