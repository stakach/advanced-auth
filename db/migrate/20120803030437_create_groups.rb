class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
			t.string	:identifier,	:allow_null => false
			t.string	:description
			t.string	:timezone
			
			t.string	:domain				# As we want to map authentication to domains
			
			t.text		:notes
			
			
			t.integer 		:parent_id		# Management structures
      t.timestamps
    end
    
   		 #
		# Group management tree
		#
		create_table :group_hierarchies, :id => false do |t|
			t.integer  :ancestor_id,	:null => false	# ID of the parent/grandparent/great-grandparent/... tag
			t.integer  :descendant_id,	:null => false	# ID of the target tag
			t.integer  :generations,	:null => false	# Number of generations between the ancestor and the descendant. Parent/child = 1, for example.
	    end
	    
	    # For "all progeny of..." selects:
	    add_index :group_hierarchies, [:ancestor_id, :descendant_id], :unique => true
	    
	    # For "all ancestors of..." selects
	    add_index :group_hierarchies, [:descendant_id]
		
  end
end
