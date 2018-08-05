Rails.application.routes.draw do
  root to: 'toppages#index'

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  # ユーザの新規登録 URL を /signupにする
  get 'signup', to: 'users#new'

  # edit、destroy等を作らないために、onlyをつける
  resources :users, only: [:index, :show, :new, :create]

  resources :microposts, only: [:create, :destroy]
end
