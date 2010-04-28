require 'ostruct'

class User < ActiveRecord::Base
  class Twitter < OpenStruct; end
  class VK < OpenStruct; end

  class << self
    def register_sync(vk, twitter)
      create(
        :twitter_handle => twitter.handle,
        :twitter_username => twitter.name,
        :twitter_token => twitter.token,
        :twitter_secret => twitter.secret
      )
    end

    def sync_exists?(vk, twitter)
      exists?(:twitter_handle => twitter.handle)
    end

    def delete_sync(vk, twitter)
      find(:first, :conditions => {:twitter_handle => twitter.handle}).destroy
    end
  end
end
