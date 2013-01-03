module Alberich
  module PermissionedObject
    extend ActiveSupport::Concern
    included do
      has_many :permissions, :as => :permission_object,
               :dependent => :destroy,
               :include => [:role],
               :order => "alberich_permissions.id ASC"
    end

    def derived_permissions
      # FIXME -- real value when derived permissons model is included
      Permission.where(:permission_object_id=>self.id,
                       :permission_object_type=>self.class)
    end

    def has_privilege(permission_session, user, action, target_type=nil)
      return false if permission_session.nil? or user.nil? or action.nil?
      target_type = self.class.default_privilege_target_type if target_type.nil?
      if derived_permissions.includes(:role => :privileges,
                                      :entity => :session_entities).where(
        ["alberich_session_entities.user_id=:user and
          alberich_session_entities.permission_session_id=:permission_session_id and
          alberich_privileges.target_type=:target_type and
          alberich_privileges.action=:action",
          { :user => user.id,
            :permission_session_id => permission_session.id,
            :target_type => target_type.name,
            :action => action}]).any?
        return true
      else
        BasePermissionObject.general_permission_scope.permissions.
          includes(:role => :privileges,
                   :entity => :session_entities).where(
        ["alberich_session_entities.user_id=:user and
          alberich_session_entities.permission_session_id=:permission_session_id and
          alberich_privileges.target_type=:target_type and
          alberich_privileges.action=:action",
          { :user => user.id,
            :permission_session_id => permission_session,
            :target_type => target_type.name,
            :action => action}]).any?
      end
    end

    # Returns the list of objects to check for permissions on -- by default
    # this is empty (we don't denormalize Global permissions as they're
    # handled as a separate case.)
    def perm_ancestors
      []
    end
    # Returns the list of objects to generate derived permissions for
    # -- by default just this object
    def derived_subtree(role = nil)
      [self]
    end
    # on obj creation, set inherited permissions for new object
    def update_derived_permissions_for_ancestors
      # for create hook this should normally be empty
      old_derived_permissions = Hash[derived_permissions.map{|p| [p.permission.id,p]}]
      perm_ancestors.each do |perm_obj|
        perm_obj.permissions.each do |permission|
          if permission.role.privilege_target_match(self.class.default_privilege_target_type)
            unless old_derived_permissions.delete(permission.id)
              derived_permissions.create(:entity_id => permission.entity_id,
                                         :role_id => permission.role_id,
                                         :permission => permission)
            end
          end
        end
      end
      # anything remaining in old_derived_permissions should be removed,
      # as would be expected if this hook is triggered by removing a
      # catalog entry for a deployable
      old_derived_permissions.each do |id, derived_perm|
        derived_perm.destroy
      end
      #reload
    end
    # assign owner role so that the creating user has permissions on the object
    # Any roles defined on default_privilege_target_type with assign_to_owner==true
    # will be assigned to the passed-in user on this object
    def assign_owner_roles(user)
      roles = Role.find(:all, :conditions => ["assign_to_owner =:assign and scope=:scope",
                                              { :assign => true,
                                                :scope => self.class.default_privilege_target_type.name}])
      roles.each do |role|
        Permission.create!(:role => role, :entity => user.entity,
                           :permission_object => self)
      end
      self.reload
    end

    # Any methods here will be able to use the context of the
    # ActiveRecord model the module is included in.
    def self.included(base)
      base.class_eval do
        after_create :update_derived_permissions_for_ancestors

        # Returns the list of privilege target types that are relevant for
        # permission checking purposes. This is used in setting derived
        # permissions -- there's no need to create denormalized permissions
        # for a role which only grants Provider privileges on a Pool
        # object. By default, this is just the current object's type
        def self.active_privilege_target_types
          [self.default_privilege_target_type] + self.additional_privilege_target_types
        end
        def self.additional_privilege_target_types
          []
        end
        def self.default_privilege_target_type
          self
        end
        def self.list_for_user(permission_session, user, action,
                               target_type=self.default_privilege_target_type)
          if permission_session.nil? or user.nil? or action.nil? or target_type.nil?
            return where("1=0")
          end
          if BasePermissionObject.general_permission_scope.
              has_privilege(permission_session, user, action, target_type)
            scoped
          else
            includes([:derived_permissions => {:role => :privileges,
                                               :entity => :session_entities}]).
              where("alberich_session_entities.user_id=:user and
                     alberich_session_entities.permission_session_id=:permission_session_id and
                     alberich_privileges.target_type=:target_type and
                     alberich_privileges.action=:action",
                    {:user => user.id,
                     :permission_session_id => permission_session.id,
                     :target_type => target_type.name,
                     :action => action})
          end
        end
      end
    end
  end
end
