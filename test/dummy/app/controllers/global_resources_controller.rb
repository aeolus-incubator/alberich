class GlobalResourcesController < ApplicationController
  # GET /global_resources
  # GET /global_resources.json
  def index
    #alberich global permissions check
    require_privilege(Alberich::Privilege::VIEW, GlobalResource)
    @global_resources = GlobalResource.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @global_resources }
    end
  end

  # GET /global_resources/1
  # GET /global_resources/1.json
  def show
    #alberich global permissions check
    require_privilege(Alberich::Privilege::VIEW, GlobalResource)
    @global_resource = GlobalResource.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @global_resource }
    end
  end

  # GET /global_resources/new
  # GET /global_resources/new.json
  def new
    #alberich global permissions check
    require_privilege(Alberich::Privilege::CREATE, GlobalResource)
    @global_resource = GlobalResource.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @global_resource }
    end
  end

  # GET /global_resources/1/edit
  def edit
    #alberich global permissions check
    require_privilege(Alberich::Privilege::MODIFY, GlobalResource)
    @global_resource = GlobalResource.find(params[:id])
  end

  # POST /global_resources
  # POST /global_resources.json
  def create
    @global_resource = GlobalResource.new(params[:global_resource])

    respond_to do |format|
      if @global_resource.save
        format.html { redirect_to @global_resource, notice: 'Global resource was successfully created.' }
        format.json { render json: @global_resource, status: :created, location: @global_resource }
      else
        format.html { render action: "new" }
        format.json { render json: @global_resource.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /global_resources/1
  # PUT /global_resources/1.json
  def update
    #alberich global permissions check
    require_privilege(Alberich::Privilege::MODIFY, GlobalResource)
    @global_resource = GlobalResource.find(params[:id])

    respond_to do |format|
      if @global_resource.update_attributes(params[:global_resource])
        format.html { redirect_to @global_resource, notice: 'Global resource was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @global_resource.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /global_resources/1
  # DELETE /global_resources/1.json
  def destroy
    #alberich global permissions check
    require_privilege(Alberich::Privilege::MODIFY, GlobalResource)
    @global_resource = GlobalResource.find(params[:id])
    @global_resource.destroy

    respond_to do |format|
      format.html { redirect_to global_resources_url }
      format.json { head :no_content }
    end
  end
end
