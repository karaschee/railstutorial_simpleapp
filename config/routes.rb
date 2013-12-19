SimpleApp::Application.routes.draw do
  root to: 'static_pages#home'

  resources :sessions, only: [:new, :destroy, :create]
  resources :microposts, only: [:create, :destroy]
  resources :users do
    member do # 用于单数 /users/1/following
      get :following, :followers # generate path: following_user_path, action: users#following
    end
    # collection { get :friends } # 用于复数 /users/friends
  end
  resources :relationships, only: [:create, :destroy]
  get '/signup' => 'users#new'
  get '/signin' => 'sessions#new'
  delete '/signout' => 'sessions#destroy'

  match '/help',    to: 'static_pages#help',    via: 'get' # this is a named route, can generate help_path and help_url helper method
  match '/contact' => 'static_pages#contact', via: 'get' # can be simplifed
  get '/about',   to: 'static_pages#about'#, as: 'about' # can be omit

  # get "static_pages/home" # normal routes
  # get "static_pages/help"
  # get "static_pages/about"
  # get "static_pages/contact"


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
