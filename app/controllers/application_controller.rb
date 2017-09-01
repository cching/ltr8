class ApplicationController < ActionController::Base
# Prevent CSRF attacks by raising an exception.
# For APIs, you may want to use :null_session instead.
	rescue_from ActiveRecord::RecordNotFound, :with => :render_404 
	rescue_from ActionController::RoutingError, :with => :render_404

	def render_404
		respond_to do |format|
		format.html { redirect_to movie_path(71481), status: 404 }
		end
	end
end
