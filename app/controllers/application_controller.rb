class ApplicationController < ActionController::Base
  helper :all
  protect_from_forgery
  
  helper_method :current_twitter_user, :twitter_user_loggedin?

  def current_vk_user
    @current_vk_user || session[:vk]
  end

  def current_vk_user=(vk)
    @current_vk_user = session[:vk] = vk
  end

  def vk_user_loggedin?
    !current_vk_user.blank?
  end

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
