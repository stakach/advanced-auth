class CreateUserGroups < ActiveRecord::Migration
  def change
    create_table :user_groups do |t|
		t.integer :user_id
		t.integer :group_id
		t.integer :permissions
		t.text		:notes
      t.timestamps
    end
  end
end
