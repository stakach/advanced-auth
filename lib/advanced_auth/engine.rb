module AdvancedAuth
	class Engine < ::Rails::Engine
		engine_name :advanced_auth
		
		
		#
		# Create the structures required for class mix ins
		#
		config.before_initialize do |app|						# Rails.configuration
			app.config.advanced_auth = ActiveSupport::OrderedOptions.new
			#app.config.advanced_auth.group_mixin
			#app.config.advanced_auth.user_mixin
			#app.config.advanced_auth.ug_mixin
			app.config.advanced_auth.redirection = proc { redirect_to authentications_path }
			app.config.advanced_auth.login_title = "Login"
			app.config.advanced_auth.invite_title = "Invite"
		end
		
		
		initializer 'advanced_auth.controller' do |app|
			
			ActiveSupport.on_load(:action_controller) do
				include AdvancedAuthActionControllerExtension
			end
			
		end
		
		
		#
		# Mix in the additions to the classes
		#
		config.after_initialize do |app|
			Group.class_eval &app.config.advanced_auth.group_mixin unless app.config.advanced_auth.group_mixin.nil?
			User.class_eval &app.config.advanced_auth.user_mixin unless app.config.advanced_auth.user_mixin.nil?
			UserGroup.class_eval &app.config.advanced_auth.ug_mixin unless app.config.advanced_auth.ug_mixin.nil?
		end
		
	end
	
	module AdvancedAuthActionControllerExtension
		def self.included(base)
			base.send(:include, InstanceMethods) 
			base.helper_method :current_user
			base.helper_method :current_invite
		end
		
		module InstanceMethods
			def current_user
				@current_user ||= User.find(session[:user]) if session[:user]
			rescue
				reset_session
			end
			
			def current_invite
				@current_invite ||= Invite.find(session[:invite_id]) if session[:invite_id]
			rescue
				reset_session
			end
		end
	end
end
