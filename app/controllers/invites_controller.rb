class InvitesController < AuthController
	
	
	layout 'auth_layout'
	
	
	#
	# Do you want to accept?
	# Is this you?
	#
	def show
		if current_invite.nil?
			invite = Invite.where(:id => params[:id], :secret => params[:secret]).where('expires > ?', Time.now).first
			if invite.present?
				session[:invite_id] = invite.id
			end
		end
	end
	
	
	def create
		if current_invite && current_user
			User.transaction do
				current_invite.add_to_group(current_user)
			end
			
			instance_eval &Rails.configuration.advanced_auth.redirection
		else
			
			reset_session
			redirect_to root_path
		end
	end
	
	
	#
	# The current user is not me
	#
	def update
		if current_invite.present?
			reset_session
			session[:invite_id] = current_invite.id
			redirect_to invite_path(current_invite.id)
		else
			reset_session
			redirect_to root_path
		end
	end
	
	#
	# If you don't want to accept the invite
	#
	def destroy
		if current_invite.present?
			current_invite.destroy
			session[:invite_id] = nil
		end
		
		redirect_to root_path
	end
	
end
