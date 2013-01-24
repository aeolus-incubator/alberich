class CreateAlberichBasePermissionObjects < ActiveRecord::Migration
  def change
    create_table :alberich_base_permission_objects do |t|
      t.string  :name, :null => false

      t.timestamps
    end
  end
end
