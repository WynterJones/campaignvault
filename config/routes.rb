Rails.application.routes.draw do
  resources :campaigns, param: :slug
  resources :apps, param: :slug
  resources :settings
  resources :users

  devise_for :users,
    controllers: {
      registrations: 'registrations',
      sessions: 'sessions'
    },
    :path => '',
    :path_names => {
      :sign_in =>       'login',
      :sign_out =>      'logout',
      :sign_up =>       'signup',
      :registration =>  '',
      :edit =>          'account',
      :cancel =>        'cancel',
      :confirmation =>  'verify'
    }

  root 'dashboard#index'
  get '/database/:id', to: 'requests#show', as: 'request'
  get '/export', to: 'export#export', as: 'export'
  get '/welcome', to: 'dashboard#welcome', as: 'welcome'
  get '/users', to: 'users#index'
  get '/users/new', to: 'users#new'
  get '/users/edit/:id', to: 'users#edit'
  post '/database/:id', to: 'requests#delete'
  post '/tags/:id', to: 'tags#delete'

  put '/:campaign/:app', to: 'save_request#receive'
  post '/:campaign/:app', to: 'save_request#receive'
  get '/:campaign/:app', to: 'save_request#receive'

  if Rails.env.development?
    require 'sidekiq/web'
    authenticate :user do
      mount Sidekiq::Web => '/sidekiq/dashboard'
    end
  end
end
