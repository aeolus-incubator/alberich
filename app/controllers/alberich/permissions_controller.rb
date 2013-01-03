require_dependency "alberich/application_controller"

module Alberich
  class PermissionsController < ApplicationController
    # GET /permissions
    # GET /permissions.json
    def index
      set_permission_object(Privilege::PERM_VIEW)
      @roles = Role.find_all_by_scope(@permission_object.class.name)
      respond_to do |format|
        format.html
        format.json { render :json => @permission_object.as_json }
        format.js { render :partial => 'permissions' }
      end
    end
  
    # GET /permissions/new
    # GET /permissions/new.json
    def new
      set_permission_object
      @users = Alberich.user_class.constantize.all
      @roles = Role.find_all_by_scope(@permission_object.class.name)
      if @permission_object == BasePermissionObject.general_permission_scope
        @return_text = "Global Role Grants"
        @summary_text =  "Choose Global Role"
      else
        @return_text =  "#{@permission_object.name} " +
          @permission_object.class.model_name.human
        @summary_text = "Choose roles for " +
          @permission_object.class.model_name.human
      end
      load_headers
      load_entities
      respond_to do |format|
        format.html
        format.js { render :partial => 'new' }
      end
    end

    # POST /permissions
    # POST /permissions.json
    def create
      set_permission_object
      added=[]
      not_added=[]
      params[:entity_role_selected].each do |entity_role|
        entity_id,role_id = entity_role.split(",")
        unless role_id.nil?
          permission = Permission.new(:entity_id => entity_id,
                                      :role_id => role_id,
                                      :permission_object => @permission_object)
          if permission.save
            added << "#{permission.entity.name} (#{permission.role.name})"
          else
            not_added << "#{permission.entity.name} (#{permission.role.name})"
          end
        end
      end
      unless added.empty?
        flash[:notice] = "Added the following permission grants: #{added.to_sentence}"
      end
      unless not_added.empty?
        flash[:error] = "Could not add the following permission grants: #{not_added.to_sentence}"
      end
      if added.empty? and not_added.empty?
        flash[:error] = "No users or groups selected"
      end
      respond_to do |format|
        format.html { redirect_to @return_path }
        format.js { render :partial => 'index',
                    :permission_object_type => @permission_object.class.name,
                    :permission_object_id => @permission_object.id }
      end
    end
  
    def multi_update
      set_permission_object
      modified=[]
      not_modified=[]
      params[:permission_role_selected].each do |permission_role|
        permission_id,role_id = permission_role.split(",")
        unless role_id.nil?
          permission = Permission.find(permission_id)
          role = Role.find(role_id)
          old_role = permission.role
          unless permission.role == role
            permission.role = role
            if permission.save
              modified << "%{permission.entity.name} (from %{old_role.name} to %{permission.role.name})"
            else
              not_modified << "%{permission.entity.name} (from %{old_role.name} to %{permission.role.name})"
            end
          end
        end
      end
      unless modified.empty?
        flash[:notice] = "Successfully modified the following permission records #{modified.to_sentence}"
      end
      unless not_modified.empty?
        flash[:error] = "Could not add these permission records #{not_modified.to_sentence}"
      end
      if modified.empty? and not_modified.empty?
        flash[:notice] = "All permission records already set; no changes needed"
      end
      respond_to do |format|
        format.html { redirect_to @return_path }
        format.js { render :partial => 'index',
                      :permission_object_type => @permission_object.class.name,
                      :permission_object_id => @permission_object.id }
      end
    end

    def multi_destroy
      set_permission_object
      deleted=[]
      not_deleted=[]

      Permission.find(params[:permission_selected]).each do |p|
        if check_privilege(Privilege::PERM_SET, p.permission_object) && p.destroy
          deleted << "#{p.entity.name} #{p.role.name}"
        else
          not_deleted << "#{p.entity.name} #{p.role.name}"
        end
      end

      unless deleted.empty?
        flash[:notice] = "Deleted the following Permission Grants: #{deleted.to_sentence}"
      end
      unless not_deleted.empty?
        flash[:error] = "Could not delete these Permission Grants: #{not_deleted.to_sentence}"
      end
      respond_to do |format|
        format.html { redirect_to @return_path }
        format.js { render :partial => 'index',
                      :permission_object_type => @permission_object.class.name,
                      :permission_object_id => @permission_object.id }
          format.json { render :json => @permission, :status => :created }
      end

    end
  
    # DELETE /permissions/1
    # DELETE /permissions/1.json
    def destroy
      if request.delete?
        p = Permission.find(params[:id])
        ptype, pid = [p.permission_object_type, p.permission_object_id]
        require_privilege(Privilege::PERM_SET, p.permission_object)
        p.destroy
      end
      redirect_to :action => "index",
                  :permission_object_type => ptype,
                  :permission_object_id => pid
    end

    def load_entities
      @entities = Entity.order("name")
    end

    def load_headers
      @header = [{ :name => '', :sortable => false },
                 { :name => "Name"},
                 { :name => "Role", :sortable => false }]
    end

    def set_permission_object (required_role=Privilege::PERM_SET)
      obj_type = params[:permission_object_type]
      id = params[:permission_object_id]
      @return_path = params[:return_path]
      @path_prefix = params[:path_prefix]
      @polymorphic_path_extras = params[:polymorphic_path_extras]
      @use_tabs = params[:use_tabs]
      unless obj_type or id
        @permission_object = BasePermissionObject.general_permission_scope
      end
      if obj_type && id
        if klass = ActiveRecord::Base.send(:subclasses).
            find{|c| c.name == obj_type}
          @permission_object = klass.find(id)
        else
          raise RuntimeError, "invalid permission object type #{obj_type}"
        end
      end
      raise RuntimeError, "invalid permission object" if @permission_object.nil?
      unless @return_path
        if @permission_object == BasePermissionObject.general_permission_scope
          @return_path = permissions_path(:return_from_permission_change => true)
          # FIXME probably remove this: set_admin_users_tabs 'permissions'
        else
          @return_path = send("#{@path_prefix}polymorphic_path",
                              @permission_object.respond_to?(
                                :to_polymorphic_path_param) ?
                              @permission_object.to_polymorphic_path_param(
                                @polymorphic_path_extras) :
                              @permission_object,
                              @use_tabs == "yes" ? {:details_tab => :permissions,
                                :only_tab => true,
                                :return_from_permission_change => true} :
                               {:return_from_permission_change => true})
        end
      end
      require_privilege(required_role, @permission_object)
      set_permissions_header
    end

  end
end
