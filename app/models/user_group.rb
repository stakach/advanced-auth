class UserGroup < ActiveRecord::Base
	belongs_to :group
	belongs_to :user
	
	attr_accessible :user_id, :group_id, :permissions
	
	validates_presence_of :user_id, :group_id, :permissions
end


UserGroup.class_eval &Rails.configuration.advanced_auth.ug_mixin unless Rails.configuration.advanced_auth.ug_mixin.nil?
