Alberich::Engine.routes.draw do
  resources :permissions

  resources :privileges

  resources :roles do
    resources :privileges
  end

end
