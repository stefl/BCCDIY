class UserMailer < ActionMailer::Base
  default_url_options[:host] = "bccdiy.com"
  def signup_notification(user)
    setup_email(user)
    @subject    += 'Please activate your new account'
    @body[:url]  = activate_url(user.activation_code, :host => "bccdiy.com")
  end
  
  def activation(user)
    setup_email(user)
    @subject    += 'Your account has been activated!'
    @body[:url]  = home_url
  end
  
  protected
    def setup_email(user)
      @recipients  = "#{user.email}"
      @from        = "ADMINEMAIL"
      @subject     = "[BCCDIY] "
      @sent_on     = Time.now
      @body[:user] = user
    end
end
