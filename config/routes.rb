Alberich::Engine.routes.draw do
  resources :privileges

  resources :roles do
    resources :privileges
  end

end
