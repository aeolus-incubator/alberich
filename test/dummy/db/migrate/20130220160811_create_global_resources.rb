class CreateGlobalResources < ActiveRecord::Migration
  def change
    create_table :global_resources do |t|
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
