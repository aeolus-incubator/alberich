Alberich::Engine.routes.draw do
  resources :permissions do
    collection do
      get :list
      delete :multi_destroy
      post :multi_update
    end
  end


  resources :privileges

  resources :roles do
    resources :privileges
  end

end
