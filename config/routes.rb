Plantr::Application.routes.draw do

  devise_for :users
  mount ApiTaster::Engine => "/api_taster" if Rails.env.development?

  # root :to => "users#index"
  # mount Plantr::API => '/'

  root :to => "home#index"


  resources :sensors

  resources :gardens do
    resources :plants
  end

  resources :logs


  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end

if Rails.env.development?
  ApiTaster.routes do
    desc 'Get a list of gardens for a user'
    get '/gardens.json'

    desc 'Create a garden'
    post '/gardens.json', {
      :name => 'My Garden'
    }

    desc 'Delete a garden'

    desc 'Get a list of plants for a garden'
    get '/gardens/:garden_id/plants.json', {
      :garden_id => 1
    }

    desc 'Sign in a user'
    post '/users/sign_in.json', {
      :user => 'kylepetrovich@gmail.com',
      :password => 'poophands',
      :remember_me => 1
    }

    desc 'Sign out a user'
    delete '/users/sign_out.json'

    desc 'Create new plant'
    post '/gardens/:garden_id/plants.json', {
      :garden_id => 1,
      :name => 'Fart Plant',
      :sensor_id => 1,
      :plant_type_id => 1
    }

    desc 'Delete a plant'
    delete '/gardens/:garden_id/plants.json', {
      :garden_id => 1
    }

    desc 'fart'
  end
end


