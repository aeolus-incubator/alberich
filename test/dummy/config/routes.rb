Rails.application.routes.draw do
  resources :global_resources


  resources :user_groups do
    member do
      get 'add_members'
      get 'add_member'
      delete 'remove_member'
    end
  end

  root      :to => "users#index"

  resources :users
  resource :user_session
  match 'login',       :to => 'user_sessions#new',     :as => 'login'
  match 'logout',      :to => 'user_sessions#destroy', :as => 'logout'
  match 'register',    :to => 'users#new',             :as => 'register'

  resource  'account', :to => 'users'

  mount Alberich::Engine => "/alberich"
end
