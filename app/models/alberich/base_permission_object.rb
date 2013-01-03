module Alberich
  class BasePermissionObject < ActiveRecord::Base
    attr_accessible :name

    include PermissionedObject
    # FIXME has_many :derived_permissions, :as => :permission_object, :dependent => :destroy,
    #         :include => [:role],
    #         :order => "derived_permissions.id ASC"

    validates_presence_of :name
    validates_uniqueness_of :name

    GENERAL_PERMISSION_SCOPE = "general_permission_scope"

    def self.general_permission_scope
      base_permission = self.find_by_name(GENERAL_PERMISSION_SCOPE)
      unless base_permission
        base_permission = self.create!(:name => GENERAL_PERMISSION_SCOPE)
      end
      base_permission
    end

    def permissions_for_type(obj_type)
      role_ids = Role.where(:scope => "BasePermissionObject").
        select { |role| role.privilege_target_match(obj_type)}.collect {|r| r.id}
      permissions.where("role_id in (:role_ids)", {:role_ids => role_ids})
    end

    def self.additional_privilege_target_types
      Alberich.permissioned_object_classes.collect {|x| Kernel.const_get(x)}
    end

    def self.global_admin_permission_count
      self.general_permission_scope.permissions.includes(:role => :privileges).
        where("alberich_privileges.target_type" => "Alberich::BasePermissionObject",
              "alberich_privileges.action" => Privilege::PERM_SET).size
    end

    def self.is_global_admin_perm(permission)
      permission.role.privileges.where("alberich_privileges.target_type" =>
                                       "Alberich::BasePermissionObject",
                                       "alberich_privileges.action" =>
                                       Privilege::PERM_SET).size > 0
    end
  end
end
