class CreateChildResources < ActiveRecord::Migration
  def change
    create_table :child_resources do |t|
      t.string :name
      t.string :description
      t.references :parent_resource

      t.timestamps
    end
    add_index :child_resources, :parent_resource_id
  end
end
