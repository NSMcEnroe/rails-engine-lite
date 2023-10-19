Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  Rails.application.routes.draw do
    namespace :api do
      namespace :v1 do
        get "/merchants/find", to: "merchants#find"
        get "/merchants/find_all", to: "merchants#find_all"
        get "/items/find_all", to: "items#find_all"
        get "/items/find", to: "items#find"
        resources :merchants, only: [:index, :create, :update, :show] do
          resources :items, only: [:index]
        end
        resources :items 

        get "/items/:id/merchant", to: "item_merchants#show"
      end
    end
  end
end
