Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  resources :bookmarks, only: :index
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :bookmarks, only: [ :index, :create ]
      post '/auth/login', to: 'authentication#login'
    end
  end
end
