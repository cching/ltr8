class Review < ActiveRecord::Base
	validates :rating, :movie_id, :user_id, presence: true
	validates_uniqueness_of :user_id, :scope => :movie_id, :message => "You've already reviewed this movie."
	validates_numericality_of :rating, on: :create, :message => "Rating needs to be a number"
	validates_inclusion_of :rating, :in => 1..5, :message => "Please enter a rating for this movie."
	
	belongs_to :user

	def self.rating movie_id
		begin
			reviews = Review.where(movie_id: movie_id)
			average = (reviews.sum(:rating).to_f / (reviews.count.to_f*5))*5
			(average.is_a?(Float) && average.nan?) ? 0 : average
		rescue
			0
		end
	end
end
