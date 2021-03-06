class UserGroupsController < ApplicationController
  # GET /user_groups
  # GET /user_groups.json
  def index
    require_privilege(Alberich::Privilege::VIEW, User)
    @user_groups = UserGroup.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @user_groups }
    end
  end

  # GET /user_groups/1
  # GET /user_groups/1.json
  def show
    require_privilege(Alberich::Privilege::VIEW, User)
    @user_group = UserGroup.find(params[:id])
    add_profile_permissions_inline(Alberich::Entity.for_target(@user_group))

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user_group }
    end
  end

  # GET /user_groups/new
  # GET /user_groups/new.json
  def new
    require_privilege(Alberich::Privilege::CREATE, User)
    @user_group = UserGroup.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user_group }
    end
  end

  # GET /user_groups/1/edit
  def edit
    require_privilege(Alberich::Privilege::MODIFY, User)
    @user_group = UserGroup.find(params[:id])
  end

  # POST /user_groups
  # POST /user_groups.json
  def create
    require_privilege(Alberich::Privilege::CREATE, User)
    @user_group = UserGroup.new(params[:user_group])

    respond_to do |format|
      if @user_group.save
        format.html { redirect_to @user_group, notice: 'User group was successfully created.' }
        format.json { render json: @user_group, status: :created, location: @user_group }
      else
        format.html { render action: "new" }
        format.json { render json: @user_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /user_groups/1
  # PUT /user_groups/1.json
  def update
    require_privilege(Alberich::Privilege::MODIFY, User)
    @user_group = UserGroup.find(params[:id])

    respond_to do |format|
      if @user_group.update_attributes(params[:user_group])
        format.html { redirect_to @user_group, notice: 'User group was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_groups/1
  # DELETE /user_groups/1.json
  def destroy
    require_privilege(Alberich::Privilege::MODIFY, User)
    @user_group = UserGroup.find(params[:id])
    @user_group.destroy

    respond_to do |format|
      format.html { redirect_to user_groups_url }
      format.json { head :no_content }
    end
  end

  def add_member
    require_privilege(Alberich::Privilege::MODIFY, User)
    @user_group = UserGroup.find(params[:id])
    member = User.find(params[:user_id])
    if !@user_group.members.include?(member) and
        @user_group.members << member
      flash[:notice] = "Added member: #{member}"
    else
      flash[:notice] = "Didn't add member: #{member}"
    end
    respond_to do |format|
      format.html { redirect_to user_group_path(@user_group) }
    end

  end

  def add_members
    require_privilege(Alberich::Privilege::MODIFY, User)
    @user_group = UserGroup.find(params[:id])
    @users = User.where('users.id not in (?)',
                        @user_group.members.empty? ?
                        0 : @user_group.members.map(&:id))
  end

  def remove_member
    require_privilege(Alberich::Privilege::MODIFY, User)
    @user_group = UserGroup.find(params[:id])
    member = User.find(params[:user_id])

    if @user_group.members.delete member
      flash[:notice] = "Removed member: #{member}"
    else
      flash[:notice] = "Failed to remove member: #{member}"
    end
    respond_to do |format|
      format.html { redirect_to user_group_path(@user_group) }
    end
  end

end
