require_dependency "alberich/application_controller"

module Alberich
  class RolesController < Alberich::ApplicationController

    before_filter :require_user
    # GET /roles
    # GET /roles.json
    def index
      require_privilege(Privilege::PERM_VIEW)
      @roles = Role.all
  
      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @roles }
      end
    end
  
    # GET /roles/1
    # GET /roles/1.json
    def show
      require_privilege(Privilege::PERM_VIEW)
      @role = Role.find(params[:id])
  
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @role }
      end
    end
  
    # GET /roles/new
    # GET /roles/new.json
    def new
      require_privilege(Privilege::PERM_SET)
      @role = Role.new
      @scope_list = Role::VALID_SCOPES
      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @role }
      end
    end
  
    # GET /roles/1/edit
    def edit
      require_privilege(Privilege::PERM_SET)
      @role = Role.find(params[:id])
      @scope_list = Role::VALID_SCOPES
    end
  
    # POST /roles
    # POST /roles.json
    def create
      require_privilege(Privilege::PERM_SET)
      @role = Role.new(params[:role])
  
      respond_to do |format|
        if @role.save
          format.html { redirect_to @role, notice: "New role added"}
          format.json { render json: @role, status: :created, location: @role }
        else
          format.html { render action: "new" }
          format.json { render json: @role.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # PUT /roles/1
    # PUT /roles/1.json
    def update
      require_privilege(Privilege::PERM_SET)
      @role = Role.find(params[:id])
  
      respond_to do |format|
        if @role.update_attributes(params[:role])
          format.html { redirect_to @role, notice: "New role added"}
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @role.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # DELETE /roles/1
    # DELETE /roles/1.json
    def destroy
      require_privilege(Privilege::PERM_SET)
      @role = Role.find(params[:id])
      @role.destroy
  
      respond_to do |format|
        format.html { redirect_to roles_url }
        format.json { head :no_content }
      end
    end
  end
end
