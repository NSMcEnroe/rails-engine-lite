Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  Rails.application.routes.draw do
    namespace :api do
      namespace :v1 do
        resources :merchants, only: [:index, :show, :create, :update]
      end
    end
  end
end
