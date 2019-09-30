Rails.application.routes.draw do
  resources :clocks
  devise_for :users do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end
  root 'home#index'
end
