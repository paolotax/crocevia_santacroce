CroceviaSantacroce::Application.routes.draw do
  
  match '/cassa',   controller: 'cassa', action: 'index'
  
  resources :movimenti
  
  resources :categorie

  resources :articoli do
    # collection { post :search, to: 'articoli#index' }
  end

  resources :clienti do
    member do
      get :mandato
    end
  end

  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#index"
  
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  
  # 
  # devise_scope :user do
  #   get '/users/auth/:provider' => 'users/omniauth_callbacks#passthru'
  # end
  
  
  resources :users, :only => [:show, :index, :update]

  match '/regolamento', to: 'home#regolamento'
  match '/staff',       to: 'home#staff'
  match '/dove_siamo',   to: 'home#dove_siamo'
end
