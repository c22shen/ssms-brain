Rails.application.routes.draw do
  devise_for :users
  resources :users 

  get 'statuses/mode_update' => 'statuses#mode_update'
  get 'statuses/get_mode' => 'statuses#get_mode'
  get 'statuses/option_update' => 'statuses#option_update'
 get 'statuses/seat_location_update' => 'statuses#seat_location_update'

   get 'welcome/team' => 'welcome#team'
   
# get 'welcome/index' => 'welcome#index'
# resources :articles
root 'welcome#show'

get 'libraries/save_retrieve_comments' => 'libraries#save_retrieve_comments'
get 'libraries/set_location' => 'libraries#set_location'
get 'libraries/update_floor_chart' => 'libraries#update_floor_chart'


resources :articles do
  resources :comments
end

  resources :messages do
    collection { get :events }
  end
resources :statuses
resources :libraries




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
