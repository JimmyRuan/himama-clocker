Rails.application.routes.draw do
  resources :clocks
  devise_for :users
  root 'home#index'
end
