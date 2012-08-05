class Group < ActiveRecord::Base
	has_many	:invites
	has_many	:user_groups
	has_many 	:users,	:through => :user_groups
	
	attr_accessible :identifier, :description, :timezone, :domain, :notes, :parent_id
	
	
	acts_as_tree :name_column => :description
	
	
	validates_presence_of :description
end
