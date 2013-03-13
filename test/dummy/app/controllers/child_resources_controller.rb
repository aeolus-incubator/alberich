class ChildResourcesController < ApplicationController
  # GET /child_resources
  # GET /child_resources.json
  def index
    @child_resources = ChildResource.
      list_for_user(current_session, current_user, Alberich::Privilege::VIEW)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @child_resources }
    end
  end

  # GET /child_resources/1
  # GET /child_resources/1.json
  def show
    @child_resource = ChildResource.find(params[:id])
    # require view permissions on this object
    require_privilege(Alberich::Privilege::VIEW, @child_resource)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @child_resource }
    end
  end

  # GET /child_resources/new
  # GET /child_resources/new.json
  def new
    @parent_resource = ParentResource.find(params[:parent_resource_id])
    require_privilege(Alberich::Privilege::CREATE, ChildResource,
                      @parent_resource)
    @child_resource = ChildResource.new(:parent_resource_id=>
                                        @parent_resource.id)
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @child_resource }
    end
  end

  # GET /child_resources/1/edit
  def edit
    @child_resource = ChildResource.find(params[:id])
    # require modify permissions for this object
    require_privilege(Alberich::Privilege::MODIFY, @child_resource)
  end

  # POST /child_resources
  # POST /child_resources.json
  def create
    @parent_resource = ParentResource.find(params[:child_resource][:parent_resource_id])
    require_privilege(Alberich::Privilege::CREATE, ChildResource,
                      @parent_resource)
    @child_resource = ChildResource.new(params[:child_resource])

    respond_to do |format|
      if @child_resource.save
        @child_resource.assign_owner_roles(current_user)
        format.html { redirect_to @child_resource, notice: 'Child resource was successfully created.' }
        format.json { render json: @child_resource, status: :created, location: @child_resource }
      else
        format.html { render action: "new" }
        format.json { render json: @child_resource.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /child_resources/1
  # PUT /child_resources/1.json
  def update
    @child_resource = ChildResource.find(params[:id])
    # require modify permissions for this object
    require_privilege(Alberich::Privilege::MODIFY, @child_resource)

    respond_to do |format|
      if @child_resource.update_attributes(params[:child_resource])
        format.html { redirect_to @child_resource, notice: 'Child resource was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @child_resource.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /child_resources/1
  # DELETE /child_resources/1.json
  def destroy
    @child_resource = ChildResource.find(params[:id])
    # require modify permissions for this object
    require_privilege(Alberich::Privilege::MODIFY, @child_resource)
    @child_resource.destroy

    respond_to do |format|
      format.html { redirect_to child_resources_url }
      format.json { head :no_content }
    end
  end
end
