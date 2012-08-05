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
			app.config.advanced_auth.default_title = "Login"
			app.config.advanced_auth.invite_title = "Invite"
		end
		
		
		initializer 'advanced_auth.middleware' do |app|
			
			OmniAuth.config.logger = Rails.logger
			
			app.config.middleware.use OmniAuth::Builder do
				require 'openid/store/filesystem'
				
				provider :developer unless Rails.env.production?
				provider :twitter, ENV['TWITTER_KEY'], ENV['TWITTER_SECRET']
				provider :google_oauth2, ENV['GOOGLE_KEY'], ENV['GOOGLE_SECRET']
				provider :facebook, ENV['FACEBOOK_ID'], ENV['FACEBOOK_SECRET']
				provider :open_id, :store => OpenID::Store::Filesystem.new('/tmp')
				provider :google_apps, :store => OpenID::Store::Filesystem.new('/tmp')
				provider :identity, on_failed_registration: lambda { |env|
					IdentitiesController.action(:new).call(env)
				}
			end
			
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
				@current_user ||= User.find(session[:user_id]) if session[:user_id]
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
