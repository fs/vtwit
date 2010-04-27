ActionController::Routing::Routes.draw do |map|

  map.resource :vkontakte, :only => [:show, :create]
  map.resource :twitter, :only => [:show, :new, :create], :collection => {:create => :get }
end
