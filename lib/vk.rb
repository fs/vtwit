require 'httparty'
require 'digest/md5'

module VK
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