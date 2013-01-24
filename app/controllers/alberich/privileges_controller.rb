require_dependency "alberich/application_controller"

module Alberich
  class PrivilegesController < Alberich::ApplicationController
    # GET /privileges
    # GET /privileges.json
    def index
      require_privilege(Privilege::PERM_VIEW)
      @privileges = Privilege.all
  
      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @privileges }
      end
    end
  
    # GET /privileges/1
    # GET /privileges/1.json
    def show
      require_privilege(Privilege::PERM_VIEW)
      @privilege = Privilege.find(params[:id])
  
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @role }
      end
    end
  
    # GET /privileges/new
    # GET /privileges/new.json
    def new
      require_privilege(Privilege::PERM_SET)
      @privilege = Privilege.new(:role_id => params[:role_id])
      @target_type_list = Privilege::TARGET_TYPES
      @action_list = Privilege::ACTIONS
      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @privilege }
      end
    end
  
    # POST /privileges
    # POST /privileges.json
    def create
      require_privilege(Privilege::PERM_SET)
      @privilege = Privilege.new(params[:privilege])
      @target_type_list = Privilege::TARGET_TYPES
      @action_list = Privilege::ACTIONS
  
      respond_to do |format|
        if @privilege.save
          format.html { redirect_to @privilege.role, notice: t("privileges.flash.notice.added") }
          format.json { render json: @privilege, status: :created, location: @privilege }
        else
          format.html { render action: "new" }
          format.json { render json: @privilege.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # GET /privileges/1/edit
    def edit
      require_privilege(Privilege::PERM_SET)
      @privilege = Privilege.find(params[:id])
      @target_type_list = Privilege::TARGET_TYPES
      @action_list = Privilege::ACTIONS
      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @privilege }
      end
    end
  
    # PUT /privileges/1
    # PUT /privileges/1.json
    def update
      require_privilege(Privilege::PERM_SET)
      @privilege = Privilege.find(params[:id])
      @target_type_list = Privilege::TARGET_TYPES
      @action_list = Privilege::ACTIONS
      respond_to do |format|
        if @privilege.update_attributes(params[:privilege])
          format.html { redirect_to @privilege.role, notice: t("privileges.flash.notice.added")}
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @privilege.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # DELETE /privileges/1
    # DELETE /privileges/1.json
    def destroy
      require_privilege(Privilege::PERM_SET)
      @privilege = Privilege.find(params[:id])
      role = @privilege.role
      @privilege.destroy
  
      respond_to do |format|
        format.html { redirect_to role }
        format.json { head :no_content }
      end
    end
  end
end
