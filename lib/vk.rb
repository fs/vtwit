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

    def initialize(api_id, mid, sid, secret)
      @api_id, @mid, @sid, @secret = api_id, mid, sid, secret
    
      self.class.default_params :api_id => api_id, :sid => sid
    end

    def method_missing(method, *args)
      execute(method.to_s.split('_').join('.'), *args)
    end

    private

    def execute(method, params = {})
      query = params.update({:method => method})
      sig_params = self.class.default_params.update(query)

      self.class.post('/api.php', :query => query.update(:sig => sig(sig_params)))
    end

    def sig(params)
      sorted_params_in_string = params.except(:sid).stringify_keys.to_a.sort {|x,y| x[0] <=> y[0] }.map {|i| "#{i[0]}=#{i[1]}" }.join
      sig_string = "#{@mid}#{sorted_params_in_string}#{@secret}"

      Digest::MD5.hexdigest(sig_string)
    end
  end
end
