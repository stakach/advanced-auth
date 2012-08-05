class UserGroup < ActiveRecord::Base
	belongs_to :group
	belongs_to :user
	
	attr_accessible :user_id, :group_id, :permissions, :notes
	
	validates_presence_of :user_id, :group_id, :permissions
	validates :user_id, :uniqueness => {:scope => :group_id,	:message => "This user is already a group member"}
end


UserGroup.class_eval &Rails.configuration.advanced_auth.ug_mixin unless Rails.configuration.advanced_auth.ug_mixin.nil?
