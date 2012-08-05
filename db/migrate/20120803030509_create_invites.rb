class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
		t.integer :group_id
		t.integer :permissions
		t.string :email
		t.string :secret
		t.datetime :expires
		
      t.timestamps
    end
  end
end
