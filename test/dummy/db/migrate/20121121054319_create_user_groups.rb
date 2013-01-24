class CreateUserGroups < ActiveRecord::Migration
  def change
    create_table :user_groups do |t|
      t.string :name, :null => false
      t.string :description

      t.integer :lock_version, :default => 0
      t.timestamps
    end

    create_table :members_user_groups, :id => false do |t|
      t.integer :user_group_id, :null => false
      t.integer :member_id, :null => false
    end
  end
end
