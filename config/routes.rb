CroceviaSantacroce::Application.routes.draw do
  
  resources :photos
  
  resources :codice_fiscale, only: [:create]

  resources :messages do
  end
  
  resources :conversations, :path => "/messaggi", only: [:index, :show, :new, :create] do
    member do
      post :reply
      post :trash
      post :untrash
      post :mark_as_read
      post :mark_as_unread
    end
  end
  
  resources :documenti

  match '/cassa',   controller: 'cassa', action: 'index'
  
  resources :movimenti
  
  resources :categorie

  resources :articoli do
    get 'pagina/:page', :action => :index, :on => :collection
    # collection { post :search, to: 'articoli#index' }
  end

  resources :clienti do
    member do
      get :mandato
      get :crea_codice_fiscale
    end
    get 'pagina/:page', :action => :index, :on => :collection
  end

  authenticated :user do
    root :to => 'home#welcome'
  end
  root :to => "home#index"
  
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  
  # 
  # devise_scope :user do
  #   get '/users/auth/:provider' => 'users/omniauth_callbacks#passthru'
  # end
  
  
  resources :users, path: "/utenti", :only => [:show, :index, :update]

  match '/regolamento', to: 'home#regolamento'
  match '/staff',       to: 'home#staff'
  match '/dove_siamo',  to: 'home#dove_siamo'
  match '/carica_foto', to: 'home#upload_photo'
end
