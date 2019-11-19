Rails.application.routes.draw do
  root 'dashboard#index'

  put '~/:campaign/:app/:database', to: 'save_request#receive'
  post '~/:campaign/:app/:database', to: 'save_request#receive'
  get '~/:campaign/:app/:database', to: 'save_request#receive'

  get 'welcome', to: 'dashboard#welcome', as: 'welcome'
  get 'export', to: 'export#export', as: 'export'
  post 'database/:id', to: 'requests#delete'

  get 'new/:campaign_slug/:app_slug/database', to: 'databases#new'
  post 'create/:campaign_slug/:app_slug/database', to: 'databases#create'
  get 'edit/:campaign_slug/:app_slug/:database_slug', to: 'databases#edit'

  get 'new/:campaign_slug/app', to: 'apps#new'
  post 'create/:campaign_slug/app', to: 'apps#create'
  get 'edit/:campaign_slug/:app_slug', to: 'apps#edit'

  # Campaigns > Apps > Databases > Requests
  resources :campaigns, except: [:show], param: :slug do
    resources :apps, except: [:show], param: :slug, path: '' do
      resources :databases, except: [:show], param: :slug, path: '' do
        resources :requests, only: :index, path: ''
      end
    end
  end

  resources :settings

  get 'users', to: 'users#index'
  get 'users/new', to: 'users#new'
  get 'users/edit/:id', to: 'users#edit'

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

  if Rails.env.development?
    require 'sidekiq/web'
    authenticate :user do
      mount Sidekiq::Web => 'sidekiq/dashboard'
    end
  end
end
