Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "static_pages#home"
  get "/about", :controller => "static_pages", :action => "about"
  resources :games do
    resources :messages, only: :create
    member do
      patch :join
      put :join
      patch :forfeit
      put :forfeit
    end
  end
  resources :pieces, only: :update
  resources :users, only: :show
end
