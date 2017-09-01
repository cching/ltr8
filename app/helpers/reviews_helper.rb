module ReviewsHelper
	def review_date date
		date.strftime("%B %d, %Y")
	end
end
