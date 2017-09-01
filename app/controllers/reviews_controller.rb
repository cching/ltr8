class ReviewsController < ApplicationController
  before_action :set_review, only: [:edit]

  def index
    @reviews = Review.all
  end

  def new
    @review = Review.new
    @movie_id = params[:movie_id].to_i
    @email = cookies[:email]
  end

  def edit
  end

  def create
    user = User.where(email: params[:email]).first
    user ||= User.create(:email => params[:email])
    @movie_id = params[:movie_id].to_i

    @review = Review.new(:rating => params[:rating].to_i, :content => params[:content], :movie_id => @movie_id, :user_id => user.id)

    respond_to do |format|
      if @review.save
        format.js
        cookies.permanent[:email] = params[:email]
      else
        format.js { render :new, :movie_id =>  @movie_id}
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_review
      @review = Review.find(params[:id])
    end

end
