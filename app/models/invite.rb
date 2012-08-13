class Invite < ActiveRecord::Base
	belongs_to :group
	
	
	attr_accessible :email, :group_id, :expires
	
	
	before_create :generate_secret
	after_create :send_email
	
	
	def create_user
		user = User.create!(:email => email, :timezone => group.timezone)
		add_to_group(user)
		user
	end
	
	def add_to_group(user)
		UserGroup.find_or_create_by_user_id_and_group_id(:user_id => user.id, :group_id => group_id, :permissions => permissions, :notes => message)
		self.destroy
	end
	
	
	
	protected
	
	
	
	def generate_secret
		self.secret = Digest::SHA1.hexdigest([Time.now, rand].join)
		self.expires = 2.months.from_now if self.expires.nil?
	end
	
	
	def send_email
		InviteMailer.delay(:queue => 'mail').invite_email(self)
	end
	
	
	
	validates_presence_of :email, :group_id, :permissions
	validates_format_of :email, :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i
end


Invite.class_eval &Rails.configuration.advanced_auth.invite_mixin unless Rails.configuration.advanced_auth.invite_mixin.nil?
