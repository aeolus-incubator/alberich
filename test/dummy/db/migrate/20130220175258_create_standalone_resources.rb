class CreateStandaloneResources < ActiveRecord::Migration
  def change
    create_table :standalone_resources do |t|
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
