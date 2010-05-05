require 'ostruct'
require 'oauth/consumer'
require 'json'
require 'vk'

class User < ActiveRecord::Base
  class Twitter < OpenStruct
    def statuses(count = 1)
      response = access_token.get("/statuses/user_timeline.json?count=#{count.to_i}")

      case response
      when Net::HTTPSuccess
        JSON.parse(response.body)
      else
        []
      end
    end

    def statuses_array(count = 1)
      statuses(count).map { |s| s['text'] }
    end

    def consumer
      @oauth_consumer ||= OAuth::Consumer.new(TWITTER_AUTH_KEY, TWITTER_AUTH_SECRET, { :site => TWITTER_AUTH_URL })
    end

    def access_token
      @access_token ||= OAuth::AccessToken.new(consumer, token, secret)
    end

    class << self
      def from_user(user)
        new(
          :user => user,
          :handle => user.twitter_handle,
          :name => user.twitter_username,
          :token => user.twitter_token,
          :secret => user.twitter_secret
        )
      end
    end
  end

  class VK < OpenStruct
    def statuses
      response = ::VK::API.new(VK_API_ID, mid, sid, secret).activity_getHistory
      response.include?('response') ? response['response'] : []
    end

    def statuses_array
      statuses.map { |s| s['text'] }
    end

    class << self
      def from_user(user)
        new(
          :user => user,
          :sid => user.vk_sid,
          :mid => user.vk_mid,
          :secret => user.vk_secret,
          :expire => user.vk_expire,
          :username => user.vk_username
        )
      end
    end
  end

  def twitter
    @twitter ||= Twitter.from_user(self)
  end

  def vk
    @vk ||= VK.from_user(self)
  end

  def sync
    vk_statuses = vk.statuses(10)
    twitter_statuses = twitter.statuses(10)

    # push twitter statuses to vkontakte
    twitter_statuses.each do |status|
      vk.update_status(status) unless vk_statuses.include?(status)
    end

    # push vk statuses to twitter
    twitter_statuses.each do |status|
      twitter.update_status(status) unless twitter_statuses.include?(status)
    end
  end

  private

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
