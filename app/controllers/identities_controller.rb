class IdentitiesController < ApplicationController
	
	
	before_filter :authorise
	
	
	def new
		@identity = env['omniauth.identity']
	end
	
	
	private
	
	
	#
	# Same function in authentications 
	#
	def authorise
		return if current_user.present? || current_invite.present?
		reset_session
		redirect_to root_path, alert: "Authentication failed, please try again."
	end
	
	
end
