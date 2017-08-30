module MoviesHelper
	def movie_categories
		# Renders the categories below the now playing backdrop
		Categories.collect do |array|
			content_tag(:div, class: "col-xs-2 category_titles animated fadeIn") do 
				movie_id = Movie.define("movie", array.second).results[rand(0..19)].id
				poster = Movie.image("posters", movie_id, "w342")
				until !poster.nil?
					movie_id = Movie.define("movie", array.second).results[rand(0..19)].id
				end
				# ensures no preview category poster is nil
				tag("img", src: "#{poster}") +
				content_tag(:p, "#{array.first}")
			end
		end.join.html_safe
	end

	Categories = [
	    ['Top Rated', 'top_rated'],
	    ['Popular', 'popular'],
	    ['Now Playing', 'now_playing'],
	    ['Upcoming', 'upcoming']
  	]
end
