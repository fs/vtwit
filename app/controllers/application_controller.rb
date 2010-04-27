class ApplicationController < ActionController::Base
  helper :all
  protect_from_forgery
  
  helper_method :current_twitter_user, :twitter_user_loggedin?

  def current_twitter_user
    @current_twitter_user || session[:twitter]
  end

  def current_twitter_user=(twitter)
    @current_twitter_user = session[:twitter] = twitter
  end

  def twitter_user_loggedin?
    !current_twitter_user.blank?
  end
end
