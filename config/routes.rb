ActionController::Routing::Routes.draw do |map|

  map.resource :vkontakte, :collection => {:create => :get, :success => :get, :fail => :get }
  map.resource :twitter, :only => [:show, :new, :create, :destroy], :collection => {:create => :get }
  map.resource :sync, :only => [:show, :create, :destroy]
  map.root :vkontakte
end
