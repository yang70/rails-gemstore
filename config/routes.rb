Rails.application.routes.draw do
  root 'gem_store#index'

  constraints subdomain: 'api' do
    namespace :api, path: '/' do
      resources :products
    end
  end
end
