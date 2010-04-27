ActionController::Routing::Routes.draw do |map|

  map.resource :vkontakte, :only => [:show]
  map.resource :twitter, :only => [:show, :new, :create], :collection => {:create => :get }
end
