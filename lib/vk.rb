require 'httparty'
require 'digest/md5'
require 'active_support'

module VK
  class DesktopAuth

    mattr_accessor :base_url
    self.base_url = 'http://vkontakte.ru/login.php'

    mattr_accessor :default_options
    self.default_options = {
      :type => 'browser',
      :layout => 'popup'
    }

    class << self
      def uri(app_id, options = {})
        "#{base_url}?#{default_options.update(options).update(:app => app_id).to_query}"
      end
      
      def parse(json)
        ActiveSupport::JSON.decode(json).symbolize_keys
      end
    end
  end

  class API
    include HTTParty
  
    base_uri 'http://api.vkontakte.ru'
    default_params :v => '3.0', :format => 'JSON'
    format :json

    debug_output $stderr

    def initialize(app_id, uid, sid, secret)
      @app_id, @uid, @sid, @secret = app_id, uid, sid, secret
    
      self.class.default_params :app_id => app_id, :sid => sid
    end

    def execute(method, params = {})
      query = params.update({:method => method})
      self.class.post('/api.php', :query => query.update(:sig => sig(query)))
    end

    def sig(params)
      params.delete(:sid)
      sorted_params_in_string = params.stringify_keys.to_a.sort {|x,y| x[0] <=> y[0] }.map {|i| "#{i[0]}=#{i[1]}" }.join
      Digest::MD5.hexdigest("#{@uid}#{sorted_params_in_string}#{@secret}")
    end

  end
end