module MoviesHelper
	def movie_categories
		# Renders the categories below the now playing backdrop
		Categories.collect do |array|	
			content_tag(:div, class: "col-xs-2 animated fadeIn") do 
				link_to(search_movies_path(:category => array.second), remote: true, class: "category_links") do
					movie_id = Movie.define("movie", array.second).results[rand(0..19)].id
					poster = Movie.image("posters", movie_id, "w342")
					until !poster.nil?
						movie_id = Movie.define("movie", array.second).results[rand(0..19)].id
					end
					# ensures no preview category poster is nil
					content_tag(:div, class: "category_titles") do
						image_tag("#{poster}")  +
						content_tag(:p, "#{array.first}")
					end
				end
			end
		end.join.html_safe
	end 

	def movie_cast cast
		cast.first(5).collect {|member| [member.name, member.profile_path] }.collect do |member|
			content_tag(:div, class: "col-xs-2 cast_member") do 
				if !member[1].nil?
					image = Movie.concat_image("w185", "#{member[1]}")
				end
				image_tag("#{image ||= "missing.png"}", class: "center-block")  +
				content_tag(:p, "#{member[0]}", class: "cast_name")
			end
		end.join.html_safe
	end

	def movie_poster path
		if !path.nil? 
			src = "#{Movie.concat_image("w342", path)}"
		end

		image_tag("#{src ||= "missing.png"}") 
	end

	def movie_overview overview, id, title
		content_tag(:div, class: "overview") do 
			if overview.length > 250 
				truncate(overview, :length => 250) + tag(:br) +
				link_to(movie_path(movie_link(id, title)), class: "read_more") do 
					"Read more"
				end
			else 
				overview 
			end
		end
	end

	def movie_link id, title
		begin
			"#{id}-#{title.parameterize}"
		rescue
			id
		end
	end

	def release_date date
		if !date.nil?
			content_tag(:div, class: "movie_date") do 
				datetime_parse(date)
			end
		end
	end

	def datetime_parse date
		begin 
			DateTime.parse(date).strftime('%B %Y')
		rescue
			# for movies with inconsistent or nil dates
			""
		end
	end

	Categories = [
	    ['Top Rated', 'top_rated'],
	    ['Popular', 'popular'],
	    ['Now Playing', 'now_playing'],
	    ['Upcoming', 'upcoming']
  	]
end
