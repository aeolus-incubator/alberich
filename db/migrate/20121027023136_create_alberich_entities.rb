class CreateAlberichEntities < ActiveRecord::Migration
  class Alberich::Entity < ActiveRecord::Base; end

  def up
    create_table :alberich_entities do |t|
      t.string :name
      t.references :entity_target, :polymorphic => true, :null => false

      t.integer :lock_version, :default => 0
      t.timestamps
    end
    if Alberich.user_class.constantize.table_exists?
      Alberich.user_class.constantize.all.each do |u|
        unless u.entity
          entity = Entity.new(:entity_target => u)
          entity.name = u.to_s
          entity.save!
        end
      end
    end
    if Alberich.user_group_class.constantize.table_exists?
      Alberich.user_group_class.constantize.all.each do |ug|
        unless ug.entity
          entity = Entity.new(:entity_target => ug)
          entity.name = ug.to_s
          entity.save!
        end
      end
    end
  end
  def down
    drop_table :alberich_entities
  end
end
