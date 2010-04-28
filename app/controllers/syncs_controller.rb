class SyncsController < ApplicationController
  before_filter :require_vk_auth, :require_twitter_auth

  def show
    @sync_exists = User.sync_exists?(current_vk_user, current_twitter_user)
  end

  def create
    User.register_sync(current_vk_user, current_twitter_user)

    flash[:notice] = 'Синхронизация включена'
    redirect_to(sync_path)
  end

  def destroy
    User.delete_sync(current_vk_user, current_twitter_user)

    flash[:notice] = 'Синхронизация выключена'
    redirect_to(sync_path)
  end

end
