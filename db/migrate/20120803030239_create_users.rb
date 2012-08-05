class CreateUsers < ActiveRecord::Migration
	def change
		create_table :users do |t|
			t.string :firstname
			t.string :lastname
			t.string :email, :allow_null => false
			t.string :timezone
			t.integer :login_count
			t.boolean :system_admin
			t.timestamps
		end
	end
end
