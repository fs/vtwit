class ApplicationController < ActionController::Base
  helper :all
  protect_from_forgery
  
  helper_method :current_vk_user, :vk_user_loggedin?, :current_twitter_user, :twitter_user_loggedin?

  def current_vk_user
    @current_vk_user || session[:vk]
  end

  def current_vk_user=(vk)
    @current_vk_user = session[:vk] = vk
  end

  def vk_user_loggedin?
    !current_vk_user.blank?
  end

  def require_vk_auth
    unless vk_user_loggedin?
      flash['error'] = 'Надо залогиниться в Контакт'
      redirect_to(vkontakte_path)
    end
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

  def require_twitter_auth
    unless twitter_user_loggedin?
      flash['error'] = 'Надо залогиниться в Twitter'
      redirect_to(twitter_path)
    end
  end
end
