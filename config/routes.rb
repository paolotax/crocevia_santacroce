CroceviaSantacroce::Application.routes.draw do
  
  resources :photos, :path => "/galleria"
  
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
  
  
  match 'documenti/:year/:month/:day' => 'documenti#index',
    :constraints => { :year => /\d{4}/, :month => /\d{1,2}/, :day => /\d{1,2}/ },
    :as => 'lista_documenti'

  resources :documenti

  match '/cassa',   controller: 'cassa', action: 'index'
  
  match 'movimenti/:year/:month/:day' => 'movimenti#index',
      :constraints => { :year => /\d{4}/, :month => /\d{1,2}/, :day => /\d{1,2}/ },
      :as => 'lista_movimenti'

  resources :movimenti
  
  resources :categorie

  resources :articoli do
    get 'pagina/:page', :action => :index, :on => :collection
    # collection { post :search, to: 'articoli#index' }
    collection do
      put :etichette, format: :pdf
    end
  end

  resources :clienti do
    member do
      get :mandato
      get :tessera
      get :situazione
      get :crea_codice_fiscale
    end
    get 'pagina/:page', :action => :index, :on => :collection
  end

  authenticated :user do
    root :to => 'home#welcome'
  end
  root :to => "home#index"
  
  
  # ho dovuto cambiare nell initializer delete to get per il logout funziona ma non e corretto
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  
  
  resources :users, :only => [:show, :index, :update]


  match '/regolamento', to: 'home#regolamento'
  match '/staff',       to: 'home#staff'
  match '/dove_siamo',  to: 'home#dove_siamo'
end
