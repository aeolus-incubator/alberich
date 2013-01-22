module Alberich
  class Permission < ActiveRecord::Base
    attr_accessible :entity, :role, :entity_id, :role_id, :permission_object

    belongs_to :role
    belongs_to :entity

    validates_presence_of :role_id

    validates_presence_of :entity_id
    validates_uniqueness_of :entity_id, :scope => [:permission_object_id,
                                                   :permission_object_type,
                                                   :role_id]

    belongs_to :permission_object,      :polymorphic => true
    # type-specific associations (FIXME: do we still need this?
    belongs_to :base_permission_object, :class_name => "BasePermissionObject",
                                        :foreign_key => "permission_object_id"

    has_many :derived_permissions, :dependent => :destroy

    after_save :update_derived_permissions

    def user
      entity.user
    end
    def user_group
      entity.user_group
    end

    def update_derived_permissions
      new_derived_permission_objects = permission_object.derived_subtree(role)
      old_derived_permissions = derived_permissions
      old_derived_permissions.each do |derived_perm|
        if new_derived_permission_objects.delete(derived_perm.permission_object)
          # object is in both old and new list -- update as necessary
          derived_perm.role = role
          derived_perm.entity_id = entity_id
          derived_perm.save!
        else
          # object is in old but not new list -- remove it
          derived_perm.destroy
        end
      end
      new_derived_permission_objects.each do |perm_obj|
        unless DerivedPermission.where(:permission_id => id,
                                       :permission_object_id => perm_obj.id,
                                       :permission_object_type =>
                                         perm_obj.class.name).any?
          derived_perm = DerivedPermission.new(:entity_id => entity_id,
                                               :role_id => role_id,
                                               :permission_object => perm_obj,
                                               :permission => self)
          derived_perm.save!
        end
      end
    end
  end
end
