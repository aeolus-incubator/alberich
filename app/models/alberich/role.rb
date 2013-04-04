module Alberich
  class Role < ActiveRecord::Base
    VALID_SCOPES = ["Alberich::BasePermissionObject"] + Alberich.permissioned_object_classes
    has_many :permissions, :dependent => :destroy
    has_many :derived_permissions, :dependent => :destroy
    has_many :privileges, :dependent => :destroy

    attr_accessible :name, :assign_to_owner, :scope

    validates_presence_of :scope
    validates_presence_of :name
    validates_uniqueness_of :name

    validates_associated :privileges

    validates_length_of :name, :maximum => 255
    validates_inclusion_of :scope, :in => VALID_SCOPES
    def privilege_target_types
      privileges.collect {|x| x.target_type.constantize}.uniq
    end
    def privilege_target_match(obj_type)
      (privilege_target_types & obj_type.active_privilege_target_types).any?
    end

    def self.all_by_scope
      roles = self.all
      role_hash = {}
      roles.each do |role|
        role_hash[role.scope] ||= []
        role_hash[role.scope] << role
      end
      role_hash
    end

  end

end
