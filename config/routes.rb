Rails.application.routes.draw do

  # dashboard
  root 'dashboard#index'

  # resources
  resources :campaigns, param: :slug
  resources :apps, param: :slug, :except => [:index, :new, :edit, :show]
  resources :settings
  resources :databases, param: :slug

  # actions
  get '/export', to: 'export#export', as: 'export'

  # users
  get '/users', to: 'users#index'
  get '/users/new', to: 'users#new'
  get '/users/edit/:id', to: 'users#edit'

  # heroku license setup
  get '/welcome', to: 'dashboard#welcome', as: 'welcome'

  # delete selected via table
  post '/database/:id', to: 'requests#delete'

  # app view
  get '/campaigns/:campaign/:app', to: 'databases#index'
  get '/campaigns/:campaign/:app/:id', to: 'requests#show', as: 'request'
  get '/campaigns/:campaign/:slug/edit', to: 'apps#edit'

  # webhook url
  put '/cv/:campaign/:app/:database', to: 'save_request#receive'
  post '/cv/:campaign/:app/:database', to: 'save_request#receive'
  get '/cv/:campaign/:app/:database', to: 'save_request#receive'

  # devise
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

  # sidekiq
  if Rails.env.development?
    require 'sidekiq/web'
    authenticate :user do
      mount Sidekiq::Web => '/sidekiq/dashboard'
    end
  end
end
