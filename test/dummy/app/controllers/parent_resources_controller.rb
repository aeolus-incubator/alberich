class ParentResourcesController < ApplicationController
  # GET /parent_resources
  # GET /parent_resources.json
  def index
    #filter on view permission
    @parent_resources = ParentResource.
      list_for_user(current_session, current_user, Alberich::Privilege::VIEW)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @parent_resources }
    end
  end

  # GET /parent_resources/1
  # GET /parent_resources/1.json
  def show
    @parent_resource = ParentResource.find(params[:id])
    # require view permissions on this object
    require_privilege(Alberich::Privilege::VIEW, @parent_resource)
    @child_resources = @parent_resource.child_resources.
      list_for_user(current_session, current_user, Alberich::Privilege::VIEW)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @parent_resource }
    end
  end

  # GET /parent_resources/new
  # GET /parent_resources/new.json
  def new
    # require global create permissions for this object type
    require_privilege(Alberich::Privilege::CREATE, ParentResource)
    @parent_resource = ParentResource.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @parent_resource }
    end
  end

  # GET /parent_resources/1/edit
  def edit
    @parent_resource = ParentResource.find(params[:id])
    # require modify permissions for this object
    require_privilege(Alberich::Privilege::MODIFY, @parent_resource)
  end

  # POST /parent_resources
  # POST /parent_resources.json
  def create
    # require global create permissions for this object type
    require_privilege(Alberich::Privilege::CREATE, ParentResource)

    @parent_resource = ParentResource.new(params[:parent_resource])

    respond_to do |format|
      if @parent_resource.save
        @parent_resource.assign_owner_roles(current_user)
        format.html { redirect_to @parent_resource, notice: 'Parent resource was successfully created.' }
        format.json { render json: @parent_resource, status: :created, location: @parent_resource }
      else
        format.html { render action: "new" }
        format.json { render json: @parent_resource.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /parent_resources/1
  # PUT /parent_resources/1.json
  def update
    @parent_resource = ParentResource.find(params[:id])
    # require modify permissions for this object
    require_privilege(Alberich::Privilege::MODIFY, @parent_resource)

    respond_to do |format|
      if @parent_resource.update_attributes(params[:parent_resource])
        format.html { redirect_to @parent_resource, notice: 'Parent resource was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @parent_resource.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /parent_resources/1
  # DELETE /parent_resources/1.json
  def destroy
    @parent_resource = ParentResource.find(params[:id])
    # require modify permissions for this object
    require_privilege(Alberich::Privilege::MODIFY, @parent_resource)
    @parent_resource.destroy

    respond_to do |format|
      format.html { redirect_to parent_resources_url }
      format.json { head :no_content }
    end
  end
end
