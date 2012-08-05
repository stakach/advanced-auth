class Authentication < ActiveRecord::Base
	belongs_to :user
	
	
	attr_accessible :provider, :uid
	
  
	def provider_name
		if provider == 'open_id'
			"OpenID"
		else
			provider.titleize
		end
	end
	
	def self.from_omniauth(auth)
		find_by_provider_and_uid(auth["provider"], auth["uid"])
	end
	
end
