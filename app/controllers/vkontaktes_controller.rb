class VkontaktesController < ApplicationController
  def show
  end

  def create
    self.current_vk_user = User::VK.new({
        :sid => params[:sid],
        :uid => params[:uid],
        :username => params[:username],
      }) unless params[:sid].blank?

    render :nothing => true
  end

end
