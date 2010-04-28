require 'oauth/consumer'
require 'json'

class TwittersController < ApplicationController
  TWITTER_AUTH_KEY = '46MsxfZnQg02U4Rh1U7Xow'
  TWITTER_AUTH_SECRET = 'pWMxZJyXMcMZovVWqah9244lOsH4hsOed1EVliQTPKo'
  TWITTER_AUTH_URL = 'http://twitter.com'

  def new
    @oauth_consumer = OAuth::Consumer.new(TWITTER_AUTH_KEY, TWITTER_AUTH_SECRET, { :site => TWITTER_AUTH_URL })

    @request_token = @oauth_consumer.get_request_token({
        :oauth_callback => create_twitter_url(:user_action => params[:user_action])
      })

    session[:twitter_request_token] = @request_token.token
    session[:twitter_request_token_secret] = @request_token.secret

    # Send to twitter.com to authorize
    redirect_to(@request_token.authorize_url)
  end

  def create
    @oauth_consumer = OAuth::Consumer.new(TWITTER_AUTH_KEY, TWITTER_AUTH_SECRET, { :site => TWITTER_AUTH_URL })
    @request_token = OAuth::RequestToken.new(@oauth_consumer, session[:twitter_request_token], session[:twitter_request_token_secret])

    session[:twitter_request_token] = nil
    session[:twitter_request_token_secret] = nil

    @access_token = @request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])

    response = @access_token.get('/account/verify_credentials.json')

    twitter_user_info = case response
    when Net::HTTPSuccess
      JSON.parse(response.body) # user attribtues are in here
    else
      flash[:error] = 'Не вошли!'
      redirect_to(twitter_path)
    end

    self.current_twitter_user = User::Twitter.new({
        :id => twitter_user_info['id'],
        :name => twitter_user_info['name'],
        :handle => twitter_user_info['screen_name'],
        :token => @access_token.token,
        :secret => @access_token.secret
      })

    flash[:success] = 'Вошли!'
    redirect_to(twitter_path)
  end

  def destroy
    flash['message'] = 'Вы вышли из Twitter'
    self.current_twitter_user = nil

    redirect_to(twitter_path)
  end
end