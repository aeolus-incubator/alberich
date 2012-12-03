#
#   Copyright 2012 Red Hat, Inc.
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#

require_dependency "alberich/application_controller"

module Alberich
  class RolesController < ApplicationController

    before_filter :require_user
    # GET /roles
    # GET /roles.json
    def index
      # FIXME require_privilege(Privilege::PERM_VIEW)
      # FIXME: do we paginate in the engine?
      #@roles = Role.paginate(:page => params[:page] || 1,
      #  :order => (sort_column(Role)+' '+ (sort_direction))
      #)
      @roles = Role.all
  
      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @roles }
      end
    end
  
    # GET /roles/1
    # GET /roles/1.json
    def show
      # FIXME require_privilege(Privilege::PERM_VIEW)
      @role = Role.find(params[:id])
  
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @role }
      end
    end
  
    # GET /roles/new
    # GET /roles/new.json
    def new
      # FIXME require_privilege(Privilege::PERM_SET)
      @role = Role.new
      @scope_list = Role::VALID_SCOPES
      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @role }
      end
    end
  
    # GET /roles/1/edit
    def edit
      # FIXME require_privilege(Privilege::PERM_SET)
      @role = Role.find(params[:id])
      @scope_list = Role::VALID_SCOPES
    end
  
    # POST /roles
    # POST /roles.json
    def create
      # FIXME require_privilege(Privilege::PERM_SET)
      @role = Role.new(params[:role])
  
      respond_to do |format|
        if @role.save
          format.html { redirect_to @role, notice: t("roles.flash.notice.added") }
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
      # FIXME require_privilege(Privilege::PERM_SET)
      @role = Role.find(params[:id])
  
      respond_to do |format|
        if @role.update_attributes(params[:role])
          format.html { redirect_to @role, notice: t("roles.flash.notice.added")}
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
      # FIXME require_privilege(Privilege::PERM_SET)
      @role = Role.find(params[:id])
      @role.destroy
  
      respond_to do |format|
        format.html { redirect_to roles_url }
        format.json { head :no_content }
      end
    end
  end
end
