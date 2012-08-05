class SessionsController < ApplicationController
	
	
	protect_from_forgery :except => [:create, :failure]
	
	
	def new
		#
		# TODO:: Check if a session exists and redirect if it does
		#
	end
	
	def create
		omniauth = env["omniauth.auth"]
		auth = Authentication.from_omniauth(omniauth)
		if auth
			if current_invite
				User.transaction do
					current_invite.add_to_group(auth.user)
				end
			end
			reset_session
			session[:user_id] = auth.user.id
			redirect_to authentications_path, notice: "Signed in!"		# TODO :: redirect to the same path as new
		elsif current_user
			current_user.authentications.create!(:provider => omniauth['provider'], :uid => omniauth['uid'])
			flash[:notice] = "Authentication successful."
			redirect_to authentications_path
		elsif current_invite
			user = nil
			User.transaction do
				user = current_invite.create_user	# This implicitly adds to group
				user.authentications.create!(:provider => omniauth['provider'], :uid => omniauth['uid'])
			end
			reset_session
			session[:user_id] = user.id
			redirect_to authentications_path, notice: "Signed in!"
		else
			failure
		end
	end

	def destroy
		session[:user_id] = nil
		reset_session
		redirect_to root_path, notice: "Signed out!"
	end

	def failure
		reset_session
		redirect_to root_path, alert: "Authentication failed, please try again."
	end
end
