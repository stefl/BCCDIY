ActionController::Routing::Routes.draw do |map|
  map.resources :jobs

  map.resources :planning_applications, :collection => {:planning_alerts => :get}

  map.resources :tools

  map.open_id_complete '/session', 
    :controller => "sessions", :action => "create",
    :requirements => { :method => :get }
    
  map.broken '/cs/Satellite', :controller => 'base', :action=>'broken_link'
  map.broken_link '/pages/GenerateContent', :controller => 'base', :action=>'broken_link'
  
  map.resources :users, :member => { :suspend   => :put,
                                     :settings  => :get,
                                     :make_admin => :put,
                                     :unsuspend => :put,
                                     :purge     => :delete },
                        :has_many => [:posts]

  map.activate '/activate/:activation_code', :controller => 'users',    :action => 'activate', :activation_code => nil
  map.signup   '/signup',                    :controller => 'users',    :action => 'new'
  map.login    '/login',                     :controller => 'sessions', :action => 'new'
  map.logout   '/logout',                    :controller => 'sessions', :action => 'destroy'
  map.settings '/settings',                  :controller => 'users',    :action => 'settings'
  
  map.resource  :session
  
  
  map.resources :revisions

  map.resources :daily_feeds

  map.resources :councils

  map.resources :committees

  map.resources :meetings
  
  map.resources :members

  map.resources :constituencies do |c|
    c.resources :wards, :member => {:fix_my_street => :post, :planning_alerts => :post, :plings => :post}
  end

  #also provide direct link to wards
  map.resources :wards, :collection => {:auto_complete_for_ward_name => :any}

  map.home '/', :controller=>'base', :action=>'home'
  map.news '/news', :controller=>'base', :action=>'news'
  map.contact '/contact', :controller=>'base', :action=>'contact'
  map.formatted_news '/news.:format', :controller=>'base', :action=>'news'
  map.events '/events', :controller=>'base', :action=>'events'
  map.formatted_events '/events.:format', :controller=>'base', :action=>'events'
  
  map.connect '/auto_complete_for_page_title', :controller=>'base', :action=>'auto_complete_for_page_title'
  map.connect '/auto_complete_for_ward_name', :controller=>'base', :action=>'auto_complete_for_ward_name'
  
  
  map.atoz '/pages/atoz', :controller=>'pages', :action=>'atoz'
  map.connect '/pages/atoz/:letter', :controller=>'pages', :action=>'atoz'
  map.connect '/pages/atoz/:letter.:format', :controller=>'pages', :action=>'atoz'
  
  map.resources :pages, :member=> {:hide => :post, :move=>:get}, :collection => {:auto_complete_for_page_title => :any, :go_to_title => :any, :parse_textile => :post} do |page|
    page.resources :page_versions
  end

  
  
  map.resources :page_versions

  map.connect '/:slug', :controller=>'page', :action=>'show'
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
