class CreateParentResources < ActiveRecord::Migration
  def change
    create_table :parent_resources do |t|
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
