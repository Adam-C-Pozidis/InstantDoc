Rails.application.routes.draw do
  get 'searches/home'
  devise_for :users
  root to: 'searches#home'
  get "doctors", to: 'specialties#index'
  resources :searches, only: %i[index show]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
