Plantr::Application.routes.draw do

  devise_for :users
  mount ApiTaster::Engine => "/api_taster" if Rails.env.development?

  # root :to => "users#index"
  # mount Plantr::API => '/'

  root :to => redirect("/gardens")

  resources :sensors

  resources :gardens do
    collection do
      get ':id/members' => "gardens#members"
      post ':id/members' => "gardens#add_member"
      delete ':id/members' => "gardens#remove_member"
    end
    resources :plants do
      collection do
        get ':id/logs' => "plants#logs"
      end
    end
  end

  resources :logs

  #match '*all' => 'application#cor', :constraints => {:method => 'OPTIONS'}


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
    get '/gardens'

    desc 'Create a garden'
    post '/gardens', {
      name: 'My Garden'
    }

    desc 'Delete a garden'
    delete '/gardens/:id', {
      id: 1
    }

    desc 'Get a list of plants for a garden'
    get '/gardens/:garden_id/plants/:id', {
      garden_id: 1,
      id: 1
    }

    desc 'Sign in a user'
    post '/users/sign_in', {
      user: {
        email: 'kylepetrovich@gmail.com',
        password: 'poophands',
        remember_me: 1
      } 
    }

    desc 'Sign out a user'
    delete '/users/sign_out'

    desc 'Create new plant'
    post '/gardens/:garden_id/plants', {
      garden_id: 1,
      plant: {
        name: 'Fart Plant',
        sensor_id: 1,
        plant_type_id: 1
      }
    }

    desc 'Delete a plant'
    delete '/gardens/:garden_id/plants/:id', {
      garden_id: 1,
      id: 1
    }

    desc 'Show plant details'
    get '/gardens/:garden_id/plants/:id', {
      garden_id: 1,
      id: 1
    }

    desc 'Add user to garden'
    post '/gardens/:id/members', {
      user_id: 2,
      id: 1
    }

    desc 'List members of garden'
    get '/gardens/:id/members', {
      id: 1
    }

    desc 'Get a plants logs'
    get '/gardens/:garden_id/plants/:id/logs', {
      garden_id: 1,
      id: 1
    }

    desc 'Remove self from garden'
    delete '/gardens/:id/members', {
      user_id: 2,
      id: 1
    }

    desc 'Create a log'
    post '/logs', {
      log: {
        sensor_id: 1,
        sunlight: 20,
        moisture: 20,
        temperature: 70
      }
    }

    desc 'Create a sensor'
    post '/sensors', {
      sensor: {
        name: "My Sensor",
        description: "This sensor is in the front garden."
      }
    }

  end
end


