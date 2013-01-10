module Alberich
  class DerivedPermission < ActiveRecord::Base
    attr_accessible :entity_id, :permission_id, :role_id, :permission_object
    attr_accessible :permission

    # the source permission for the denormalized object
    belongs_to :permission
    validates_presence_of :permission_id

    # this is the object used for permission checks
    belongs_to :permission_object,      :polymorphic => true

    belongs_to :role
    validates_presence_of :role_id

    # entity is copied from source permission
    belongs_to :entity
    validates_presence_of :entity_id

    validates_uniqueness_of :permission_id, :scope => [:permission_object_id,
                                                       :permission_object_type]


  end
end
