class AuthenticationsController < AuthController
	
	
	layout 'auth_layout'
	before_filter :authorise
	
	
	def index
		@authentications = session[:user].present? ? current_user.authentications : []		# We do want to use user_id here!
	end
	
	def destroy
		@authentication = current_user.authentications.find(params[:id])
		@authentication.destroy
		flash[:notice] = "Successfully destroyed authentication."
		redirect_to authentications_path
	end
	
	
	
	private
	
	
	#
	# Same function in authentications 
	#
	def authorise
		if current_user.nil? && current_invite.nil?
			reset_session
			redirect_to root_path, alert: "Authentication failed, please try again."
		end
	end
	
end
