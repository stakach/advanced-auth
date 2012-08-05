class ApplicationController < ActionController::Base
	protect_from_forgery


	private


	def current_user
		@current_user ||= User.find(session[:user_id]) if session[:user_id]
	rescue
		reset_session
	end
	
	def current_invite
		@current_invite ||= Invite.find(session[:invite_id]) if session[:invite_id]
	rescue
		reset_session
	end
	
	
	helper_method :current_user
	helper_method :current_invite
end
