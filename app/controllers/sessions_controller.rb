class SessionsController < AuthController
	
	
	protect_from_forgery :except => [:create, :failure]
	
	layout 'auth_layout'
	
	
	def new
		if current_user.present?
			instance_eval &Rails.configuration.advanced_auth.redirection
		else
			@org = Rails.configuration.advanced_auth.org_name
		end
	end
	
	def create
		
		#render :text => env["omniauth.auth"]['extra']['raw_info']['memberof'].to_json, :layout => false
		#return
		omniauth = env["omniauth.auth"]
		auth = Authentication.from_omniauth(omniauth)
		if auth
			if current_invite
				User.transaction do
					current_invite.add_to_group(auth.user)
				end
			end
			reset_session
			session[:user] = auth.user.id
			instance_eval &Rails.configuration.advanced_auth.redirection
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
			session[:user] = user.id
			redirect_to authentications_path, notice: "Signed in!"
		elsif omniauth['provider'] == 'ldap'
			groups = omniauth['extra']['raw_info']['memberof'].map {|e| /CN=([^,]+?)[,$]/i.match(e).captures.first }
			
			if groups.present?
				if Group.where('identifier IN (?)', groups).exists?
					User.transaction do
						email = omniauth['info']['email'] if omniauth['info']['email'].present?
						email ||= omniauth['extra']['raw_info']['userprincipalname']
						user = User.find_or_create_by_email(:email => email, :firstname => omniauth['info']['first_name'], :lastname => omniauth['info']['last_name'])
						user.authentications.create!(:provider => omniauth['provider'], :uid => omniauth['uid'])
						Group.where('identifier IN (?)', groups).find_each do |group|
							ug = UserGroup.find_or_create_by_user_id_and_group_id(:group_id => group.id, :user_id => user.id, :permissions => 0)
						end
					end
					
					reset_session
					session[:user] = user.id
					redirect_to authentications_path, notice: "Signed in!"
				else
					failure
				end
			end
		else
			failure
		end
	end

	def destroy
		session[:user] = nil
		reset_session
		redirect_to root_path, notice: "Signed out!"
	end

	def failure
		if current_invite
			redirect_to invite_path(current_invite.id), alert: "Authentication failed, please try again."
		else
			reset_session
			redirect_to root_path, alert: "Authentication failed, please try again."
		end
	end
end
