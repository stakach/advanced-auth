class Invite < ActiveRecord::Base
	belongs_to :group
	
	
	attr_accessible :email, :group_id
	
	
	before_create :generate_secret
	
	
	def create_user
		user = User.create!(:email => email, :timezone => group.timezone)
		add_to_group(user)
		user
	end
	
	def add_to_group(user)
		UserGroup.create!(:user_id => user.id, :group_id => group_id, :permissions => permissions)
		self.destroy
	end
	
	
	
	protected
	
	
	
	def generate_secret
		self.secret = Digest::SHA1.hexdigest([Time.now, rand].join)
	end
	
	
	
	validates_presence_of :email, :group_id, :permissions
	validates_uniqueness_of :email
	validates_format_of :email, :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i
end
