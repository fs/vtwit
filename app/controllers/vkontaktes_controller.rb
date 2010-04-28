class VkontaktesController < ApplicationController
  def show
  end

  def create
    self.current_vk_user = User::VK.new({
        :sid => params[:sid],
        :uid => params[:uid],
        :secret => params[:secret],
        :username => params[:username],
      }) unless params[:sid].blank?

    render :nothing => true
  end

  def destroy
    flash['message'] = 'Вы вышли из Контакта'
    self.current_vk_user = nil

    render :nothing => true
  end

end
