Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  post 'signup', to: 'auth#signup'
  post 'login', to: 'auth#login'
  # post '/posts', to: 'posts#create'
  # resources :comments
  resources :posts do
    resources :comments
  end

end
