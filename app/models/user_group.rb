class UserGroup < ActiveRecord::Base
	attr_accessible :user_id, :group_id, :permissions
	
	validates_presence_of :user_id, :group_id, :permissions
end
