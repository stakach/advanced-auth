class User < ActiveRecord::Base
	has_many :authentications
	has_many :user_groups,	:dependent => :destroy
	has_many :groups,	:through => :user_groups
	
	
	after_save :sync_email
	
	
	attr_accessible :email, :firstname, :lastname, :timezone, :name
	
	
	def name
		"#{self.firstname} #{self.lastname}"
	end
	
	
	def name=(newname)
		newname = newname.split(' ', 2)
		self[:firstname] = newname[0]
		self[:lastname] = newname[1] if newname.length > 1
	end
	
	
	protected
	
	
	def sync_email
		ids = self.authentications.where(:provider => 'identity').pluck(:uid)
		Identity.where('id IN (?)', ids).update_all(:email => self.email) unless ids.empty?
	end
	
	validates_presence_of :email
	validates_uniqueness_of :email
	validates_format_of :email, :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i
end


User.class_eval &Rails.configuration.advanced_auth.user_mixin unless Rails.configuration.advanced_auth.user_mixin.nil?

