class Movie < ActiveRecord::Base
	def self.image image_type, movie_id, style
		# return image url for a given movie
		# image_type: backdrop, poster
		# movie_id: tmdb internal ID
		# style: original, w300, etc sizes
		results = self.define("movie", image_type, movie_id)

		begin
			if results.any?
				self.concat_image(style, results.first.file_path)
				# concat image url
			end
		rescue
			nil
			# return nil if no movie is found with given ID
		end
	end

	def self.concat_image style, path 
		self.base_url + style + path
	end

	def self.define klass_name, method_name, params = nil, query = nil
		# Dynamically call class and method name on Tmdb module
		# klass_name: Collection, Movie, Search, etc
		# method_name: backdrops, posters, top rated, popular, etc
		begin
			klass = "Tmdb::#{klass_name.humanize}".constantize	
			if klass.respond_to? method_name
				if params.nil?
					klass.public_send(method_name) 
					# movie categories (popular, top rated, etc) do not take a movie ID input
				elsif !query.nil?
					klass.public_send(method_name, query, params)
					# extra query for searching method
				elsif params.is_a?(Hash)
					klass.public_send(method_name, params)
					# sort_by requires a key and value
				else
					klass.public_send(method_name, params) 
					# movie images (backdrops, posters) require movie ID
				end
			end
			# Normally, dynamically calling object methods can be dangerous, but method does not accept user input values
		rescue
			nil
			# return nil if class or method doesn't exist for Tmdb module
		end
	end

	def self.base_url
		"https://image.tmdb.org/t/p/" 
		# require secure base url to prevent unsecure resources being loaded over https
	end

	def self.config
		Tmdb::Configuration.get
		# get system wide configuration info
	end

	def self.params_exist param
		param && !param.empty?
	end
end
