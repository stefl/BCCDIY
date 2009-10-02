# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  
  helper :all
  helper_method :current_page
  before_filter :login_required, :only => [:new, :edit, :create, :update, :destroy]
  before_filter :admin_required, :only => [:destroy]
  
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  protected
    def admin_required
      admin? || access_denied
    end
end
