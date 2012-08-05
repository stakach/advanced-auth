class User < ActiveRecord::Base
	has_many :authentications
	has_many :user_groups
	has_many :groups,	:through => :user_groups
	
	
	attr_accessible :email, :firstname, :lastname, :timezone, :notes
	
	
	validates_presence_of :email
	validates_uniqueness_of :email
	validates_format_of :email, :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i
end
