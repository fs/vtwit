require 'ostruct'

class User < ActiveRecord::Base
  class Twitter < OpenStruct; end
  class VK < OpenStruct; end

  class << self
    def register_sync(vk, twitter)
      create(
        :vk_sid => vk.sid,
        :vk_mid => vk.mid,
        :vk_secret => vk.secret,
        :vk_expire => Time.at(vk.expire.to_i),
        :vk_username => vk.mid,
        :twitter_handle => twitter.handle,
        :twitter_username => twitter.name,
        :twitter_token => twitter.token,
        :twitter_secret => twitter.secret
      )
    end

    def sync_exists?(vk, twitter)
      exists?(:twitter_handle => twitter.handle, :vk_mid => vk.mid)
    end

    def delete_sync(vk, twitter)
      find(:first, :conditions => {:twitter_handle => twitter.handle, :vk_mid => vk.mid}).destroy
    end
  end
end
