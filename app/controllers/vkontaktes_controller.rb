require 'vk'
require 'ruby-debug'

class VkontaktesController < ApplicationController
  def show
  end

  def new
    redirect_to(VK::DesktopAuth.uri(VK_APP_ID, :success_url => success_vkontakte_url, :fail_url => fail_vkontakte_url))
  end

  def success
    render :action => 'success', :layout => 'blank'
  end

  def fail
    flash[:error] = 'Не удалось авторизоваться в Контакте'
    redirect_to(vkontakte_path)
  end

  def create
    redirect_to(vkontakte_path) && return if params[:session].blank?

    vk_session = VK::DesktopAuth.parse(params[:session])
    self.current_vk_user = User::VK.new(vk_session) unless vk_session[:sid].blank?

    flash[:notice] = 'Вы вошли в Контакт, а теперь войдите в Twitter'
    redirect_to(twitter_path)
  end

  def destroy
    flash['message'] = 'Вы вышли из Контакта'
    self.current_vk_user = nil

    redirect_to(vkontakte_path)
  end

end
