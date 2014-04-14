class Group < ActiveRecord::Base
	has_many	:invites
	has_many	:user_groups,	:dependent => :destroy
	has_many 	:users,	:through => :user_groups
	
	attr_accessible :identifier, :description, :timezone, :domain, :notes, :parent_id
	
	
	acts_as_tree :name_column => :description, :with_advisory_lock => false
	
	
	validates_presence_of :description
end

Group.class_eval &Rails.configuration.advanced_auth.group_mixin unless Rails.configuration.advanced_auth.group_mixin.nil?
