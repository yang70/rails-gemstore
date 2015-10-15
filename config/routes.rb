Rails.application.routes.draw do
  devise_for :users
  root 'gem_store#index'

  resources :products
end
