class Group < ActiveRecord::Base
	attr_accessible :identifier, :description, :timezone, :domain, :notes, :parent_id
	
	
	acts_as_tree :name_column => :description
	
	
	validates_presence_of :description
end
