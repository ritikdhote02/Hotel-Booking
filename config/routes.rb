Rails.application.routes.draw do
  resources :timers
  get "start_timer", to: "timers#start_timer"
  resources :tasks
  resource :users
  post "user/login", to: "users#login"

  resources :users, only: [] do
    collection do
      post 'forgot_password'
      post 'reset_password'
    end
  end
  
end
