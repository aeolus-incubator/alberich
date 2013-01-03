module Alberich
  module ApplicationControllerHelper
    class PermissionError < RuntimeError; end
    def self.included(c)
      c.helper_method :current_session, :current_user, :check_privilege
    end

    def current_session
      @current_session ||= Alberich::PermissionSession.
        find_by_id(session[:permission_session_id])
    end

    def add_profile_permissions_inline(entity, path_prefix = '')
      @entity = entity
      @path_prefix = path_prefix
      @roles = Role.all_by_scope
      @inline = true
      set_permissions_header(@entity)
    end

    def add_permissions_common(inline, perm_obj, path_prefix = '',
                               polymorphic_path_extras = {})
      @permission_object = perm_obj
      # FIXME find a way to remove the @inline bit here
      @inline = inline
      @path_prefix = path_prefix
      @polymorphic_path_extras = polymorphic_path_extras
      if check_privilege(Privilege::PERM_VIEW, perm_obj)
        @roles = Role.find_all_by_scope(@permission_object.class.name)
      end
      set_permissions_header
    end
    def add_permissions_inline(perm_obj, path_prefix = '',
                               polymorphic_path_extras = {})
      add_permissions_common(true, perm_obj, path_prefix,
                             polymorphic_path_extras)
      require_privilege(Privilege::VIEW, @permission_object)
    end

    def set_permissions_header(perm_obj = @permission_object)
      unless perm_obj == BasePermissionObject.general_permission_scope
        @show_inherited = params[:show_inherited]
        @show_global = params[:show_global]
      end
      if @show_inherited
        @permissions = perm_obj.derived_permissions
      elsif @show_global
        @permissions = BasePermissionObject.general_permission_scope.
          permissions_for_type(perm_obj.class)
      else
        @permissions = perm_obj.permissions
      end

      @permission_list_header = []
      unless (@show_inherited or @show_global)
        @permission_list_header <<
          { :name => 'checkbox', :class => 'checkbox', :sortable => false }
      end
      @permission_list_header += [
        { :name => "Type"},
        { :name => "Name"},
        { :name => "Role", :sort_attr => :role},
      ]
      if @show_inherited
        @permission_list_header <<
          { :name => "Inherited from", :sortable => false }
      end
    end

    def check_privilege(action, *type_and_perm_obj)
      target_type = nil
      perm_obj = nil
      type_and_perm_obj.each do |obj|
        target_type=obj if obj.class==Class
        perm_obj=obj if obj.is_a?(ActiveRecord::Base)
      end
      perm_obj=@perm_obj if perm_obj.nil?
      perm_obj=BasePermissionObject.general_permission_scope if perm_obj.nil?
      perm_obj.has_privilege(current_session, current_user, action, target_type)
    end

    # Require a given privilege level to view this page
    #   1. action is required -- what action to check (in Privilege::ACTIONS)
    #   2. perm_obj is optional -- This is the resource on which to look for
    #      permission records. If omitted, check for site-wide permissions on
    #      BasePermissionObject
    #   3. type is also optional -- if omitted it's taken from perm_obj.
    #        For example, if action is 'view', perm_obj is a Pool and type is
    #        omitted, then check for current user's "view pool" permission on
    #        this pool. if action is 'view', perm_obj is a Pool and type is
    #        Quota, then check for current user's "view quota" permission on 
    #        this pool.
    def require_privilege(action, *type_and_perm_obj)
      perm_obj = nil
      type_and_perm_obj.each do |obj|
        perm_obj=obj if obj.is_a?(ActiveRecord::Base)
      end
      @perm_obj = perm_obj
      unless check_privilege(action, *type_and_perm_obj)
        raise PermissionError.new(
               "You do not have permission to access this resource")
      end
    end

  end
end
