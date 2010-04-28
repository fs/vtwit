ActionController::Routing::Routes.draw do |map|

  map.resource :vkontakte, :only => [:show, :create, :destroy]
  map.resource :twitter, :only => [:show, :new, :create, :destroy], :collection => {:create => :get }
  map.resource :sync, :only => [:show, :create, :destroy]
end
