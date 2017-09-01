class Review < ActiveRecord::Base
	validates :user_id, :rating, :movie_id, presence: true
	validates_numericality_of :rating, on: :create
	validates_inclusion_of :rating, :in => 1..5, :message => "Select a rating for this movie."
	validates_uniqueness_of :user_id, :message => "You've already reviewed this movie."

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
