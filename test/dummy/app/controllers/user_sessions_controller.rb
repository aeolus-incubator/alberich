class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy

  def new
    @title = "Login"
  end

  def create
    authenticate!
    respond_to do |format|
      format.html do
        redirect_to back_or_default_url(root_url)
      end
      format.js do
        render :js => "window.location.href = '#{back_or_default_url root_url}'"
      end
    end
  end

  def unauthenticated
    Rails.logger.warn "Request is unauthenticated for #{request.remote_ip}"

    respond_to do |format|
      format.html do
        flash.now[:warning] = "Login Failed"
        render :action => :new
      end
      format.xml { head :unauthorized }
      format.js { head :unauthorized }
    end
  end

  def destroy
    logout
    redirect_to login_url
  end
end
