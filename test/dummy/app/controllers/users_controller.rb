class UsersController < ApplicationController
  before_filter :require_user

  def index
    require_privilege(Alberich::Privilege::VIEW, User)
    @title = "Users"
    @params = params
    @users = User.all
    respond_to do |format|
      format.html
    end
  end

  def new
    require_privilege(Alberich::Privilege::CREATE, User)
    @title = "New User"
    @user = User.new
  end

  def create
    require_privilege(Alberich::Privilege::CREATE, User)
    @user = User.new(params[:user])
    @title = "New User"
    unless @user.save
      render :action => 'new' and return
    end

    if current_user != @user
      flash[:notice] = "User Registered"
      redirect_to users_url
    else
      flash[:notice] = "You have registered"
      redirect_to root_url
    end
  end

  def show
    @user = params[:id] ? User.find(params[:id]) : current_user
    require_privilege(Alberich::Privilege::VIEW, User) unless current_user == @user
    @title = @user.name.present? ? @user.name : @user.username
    if current_user == user
      current_session.update_session_entities(current_user)
    end
    @user_groups = @user.all_groups
    add_profile_permissions_inline(Alberich::Entity.for_target(@user))
    respond_to do |format|
      format.html
    end
  end

  def edit
    @user = params[:id] ? User.find(params[:id]) : current_user
    require_privilege(Alberich::Privilege::MODIFY, User) unless @user == current_user
    @title = "Edit User"
  end

  def update
    @title = "Edit User"
    @user = params[:id] ? User.find(params[:id]) : current_user
    require_privilege(Alberich::Privilege::MODIFY, User) unless @user == current_user

    if params[:commit] == "Reset"
      redirect_to edit_user_url(@user) and return
    end

    redirect_to root_url and return unless @user

    unless @user.update_attributes(params[:user])
      render :action => 'edit' and return
    else
      flash[:notice] = "User updated"
      redirect_to user_path(@user)
    end
  end

  def destroy
    require_privilege(Alberich::Privilege::MODIFY, User)
    user = User.find(params[:id])
    user.destroy
    flash[:notice] = "Deleted user"

    respond_to do |format|
      format.html { redirect_to users_path }
    end
  end

end
