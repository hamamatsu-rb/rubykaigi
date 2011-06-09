Rubykaigi::Application.routes.draw do
  scope '/:year/:locale', :constraints => {:year => /2\d{3}/, :locale => /en|ja/} do
    match 'registration',
      :to => 'registrations#index',
      :as => 'registrations'
    match 'phone_registration', :to => 'registrations#phone_index'
    resources :advent_calendar, :only => %w(index)
    match 'sponsors_ruby/:id', :to => 'sponsors_ruby#show'
    match 'schedule/grid' => 'schedule#grid'
    match 'schedule/details/:id' => 'schedule#details', :as => 'schedule_details'
    resources :team, :only => %w(index)
  end

  scope '/:year', :constraints => {:year => /2\d{3}/} do
    match 'schedule/all.:format' => 'schedule#all'
  end

  match '/auth/failure'            => 'sessions#failure'
  match '/auth/:provider/callback' => 'sessions#create'
  match '/signin'                  => 'sessions#new', :as => :signin
  match '/signout'                 => 'sessions#destroy', :as => :signout

  match 'my_tickets', :to => 'tickets#index', :as => "my_tickets"

  resource :account
  resources :rubyists

  resources :carts do
    collection do
      post :add_item
      delete :remove_item
    end
  end
  resources :orders do
    collection do
      get :confirm
      get :thanks
      get :returned
      get :individual_sponsor_option
    end
  end
  resources :tickets do
    member do
      put :regenerate_permalink
    end
  end

  match "/paypal/instant_payment_notification",
    :to => 'paypal#instant_payment_notification',
    :as => 'paypal_ipn'
  match 'dashboard',
    :to => 'dashboard#index',
    :as => 'dashboard'

  scope ':year', :to => 'pages#show', :defaults => {:page_name => "index"} do
    match ':locale(/:page_name)',
      :as => 'page',
      :constraints => {:year => /2\d{3}/, :locale => /en|ja/ }
    match '(/:page_name)',
      :constraints => {:year => /2\d{3}/}
  end

  root :to => 'welcome#index'

  match ':controller(/:action(/:id))'
end
