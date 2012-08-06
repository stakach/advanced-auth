class Authentication < ActiveRecord::Base
	belongs_to :user
	
	
	after_destroy :remove_identity
	
	
	attr_accessible :provider, :uid
	
  
	def provider_name
		case provider.to_sym
			when :open_id then "OpenID"
			when :identity then "ACA Signage"
			else provider.titleize
		end
	end
	
	def self.from_omniauth(auth)
		find_by_provider_and_uid(auth["provider"], auth["uid"])
	end
	
	
	protected
	
	
	def remove_identity
		if provider.to_sym == :identity
			Identity.find(self.uid).destroy
		end
		if !self.user.authentications.exists?
			self.user.destroy
		end
	end
	
end
