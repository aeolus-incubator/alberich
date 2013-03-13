class ApplicationController < ActionController::Base
  protect_from_forgery

  def require_user
    return if current_user or http_auth_user
    respond_to do |format|
      format.html do
        store_location
        flash[:notice] = "Please log in first."
        redirect_to login_url
      end
      format.js { head :unauthorized }
      format.xml { head :unauthorized }
      format.json { head :unauthorized }
    end
  end

  def require_user_api
    return if current_user or http_auth_user
    respond_to do |format|
      format.xml { head :unauthorized }
    end
  end

  def require_no_user
    return true unless current_user
    store_location
    flash[:notice] = "You must be logged out to access this page."
    redirect_to account_url
  end

  def http_auth_user
    return unless request.authorization && request.authorization =~ /^Basic (.*)/m
    authenticate!(:scope => :api)
    frozen = request.session_options.frozen?
    request.session_options = request.session_options.dup if frozen
    request.session_options[:expire_after] = 2.minutes
    request.session_options.freeze if frozen
    # we use :api scope for authentication to avoid saving session.
    # But it's handy to set authenticated user in default scope, so we
    # can use current_user, instead of current_user(:api)
    env['warden'].set_user(user(:api)) if user(:api)
    return user(:api)
  end

  def store_location
    session[:return_to] = request.get? ? request.fullpath : request.referer
  end

  def back_or_default_url(default)
    return session[:return_to] || default
    session[:return_to] = nil
  end

  def add_permissions_tab(perm_obj, path_prefix = '',
                          polymorphic_path_extras = {})
    add_permissions_common(false, perm_obj, path_prefix,
                           polymorphic_path_extras)
    if "permissions" == params[:details_tab]
      require_privilege(Privilege::PERM_VIEW, perm_obj)
    end
    if check_privilege(Privilege::PERM_VIEW, perm_obj)
      if @tabs
        @tabs << {:name => "Role Assignments",
                  :view => 'permissions/permissions',
                  :id => 'permissions',
                  :count => perm_obj.permissions.count,
                  :pretty_view_toggle => 'disabled'}
      end
    end
  end

end
