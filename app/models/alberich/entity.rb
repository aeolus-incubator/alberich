module Alberich
  class Entity < ActiveRecord::Base
    attr_accessible :entity_target, :name

    belongs_to :entity_target, :polymorphic => true
    validates_presence_of :entity_target_id
    has_many :session_entities, :dependent => :destroy
    # FIXME has_many :permissions, :dependent => :destroy
    # FIXME has_many :derived_permissions, :dependent => :destroy

    # type-specific associations
    belongs_to :user, :class_name => Alberich.user_class, :foreign_key => "entity_target_id"
    belongs_to :user_group, :class_name => Alberich.user_group_class,
                            :foreign_key => "entity_target_id"

    def self.for_target(obj)
      self.find_by_entity_target_id_and_entity_target_type(obj.id,
                                                           obj.class.name)
    end

    def self.find_or_create_for_target(obj)
      self.find_or_create_by_entity_target_id_and_entity_target_type(obj.id,
                                                                 obj.class.name)
    end

  end
end
