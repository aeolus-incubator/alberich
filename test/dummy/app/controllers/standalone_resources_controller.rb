class StandaloneResourcesController < ApplicationController
  # GET /standalone_resources
  # GET /standalone_resources.json
  def index
    #filter on view permission
    @standalone_resources = StandaloneResource.
      list_for_user(current_session, current_user, Alberich::Privilege::VIEW)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @standalone_resources }
    end
  end

  # GET /standalone_resources/1
  # GET /standalone_resources/1.json
  def show
    @standalone_resource = StandaloneResource.find(params[:id])
    # require view permissions on this object
    require_privilege(Alberich::Privilege::VIEW, @standalone_resource)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @standalone_resource }
    end
  end

  # GET /standalone_resources/new
  # GET /standalone_resources/new.json
  def new
    # require global create permissions for this object type
    require_privilege(Alberich::Privilege::CREATE, StandaloneResource)

    @standalone_resource = StandaloneResource.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @standalone_resource }
    end
  end

  # GET /standalone_resources/1/edit
  def edit
    @standalone_resource = StandaloneResource.find(params[:id])
    # require modify permissions for this object
    require_privilege(Alberich::Privilege::MODIFY, @standalone_resource)
  end

  # POST /standalone_resources
  # POST /standalone_resources.json
  def create
    # require global create permissions for this object type
    require_privilege(Alberich::Privilege::CREATE, StandaloneResource)

    @standalone_resource = StandaloneResource.new(params[:standalone_resource])

    respond_to do |format|
      if @standalone_resource.save
        @standalone_resource.assign_owner_roles(current_user)
        format.html { redirect_to @standalone_resource, notice: 'Standalone resource was successfully created.' }
        format.json { render json: @standalone_resource, status: :created, location: @standalone_resource }
      else
        format.html { render action: "new" }
        format.json { render json: @standalone_resource.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /standalone_resources/1
  # PUT /standalone_resources/1.json
  def update
    @standalone_resource = StandaloneResource.find(params[:id])
    # require modify permissions for this object
    require_privilege(Alberich::Privilege::MODIFY, @standalone_resource)

    respond_to do |format|
      if @standalone_resource.update_attributes(params[:standalone_resource])
        format.html { redirect_to @standalone_resource, notice: 'Standalone resource was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @standalone_resource.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /standalone_resources/1
  # DELETE /standalone_resources/1.json
  def destroy
    @standalone_resource = StandaloneResource.find(params[:id])
    # require modify permissions for this object
    require_privilege(Alberich::Privilege::MODIFY, @standalone_resource)

    @standalone_resource.destroy

    respond_to do |format|
      format.html { redirect_to standalone_resources_url }
      format.json { head :no_content }
    end
  end
end
