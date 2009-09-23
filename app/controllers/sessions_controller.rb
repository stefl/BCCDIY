# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  skip_before_filter :login_required

  # render new.rhtml
  def new
  end

  def create
    reset_session
    if using_open_id?
      cookies[:use_open_id] = {:value => '1', :expires => 1.year.from_now.utc}
      open_id_authentication(params[:openid_url])
    else
      cookies[:use_open_id] = {:value => '0', :expires => 1.year.ago.utc}
      password_authentication params[:login].downcase, params[:password]
    end
  end

  def destroy
    current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = I18n.t 'txt.logged_out', :default => "You have been logged out."
    redirect_back_or_default('/')
  end

  protected
  
  def password_authentication(name, password)
    if @current_user = User.authenticate(name, password)
      successful_login
    else
      failed_login I18n.t('txt.invalid_login', :default => "Invalid login")
   end
  end

  def open_id_authentication(openid_url)
    authenticate_with_open_id(openid_url, :required => [:nickname, :email]) do |result, openid_url, registration|
    if result.successful?
      @user = User.find_or_initialize_by_openid_url(openid_url)
      @current_user  = @user
      if @current_user
        if @user.new_record?
          @user.login = openid_url
          @user.email = registration['email']
          @user.password = 123456
          @user.display_name = registration['nickname']
          @user.save(false)
        end
        successful_login
      else
        failed_login I18n.t('txt.invalid_openid', :default => "Sorry, no user by the identity URL #{openid_url} exists")
      end
    else
      failed_login result.message if openid_url
    end
  end
  end


  private
  def successful_login
    flash[:notice] = I18n.t 'txt.successful_login', :default => "Logged in successfully"
    new_cookie_flag = (params[:remember_me] == "1")
    handle_remember_cookie! new_cookie_flag
    session[:user_id] = @current_user.id
    redirect_back_or_default('/')
  end

  def failed_login(message)
    @remember_me = params[:remember_me]
    flash[:error] = message
    render :action => "new"
  end

end
