Rails.application.routes.draw do
  root 'dashboard#index'

  # Webhooks
  put '~/:user_token/:campaign/:app/:database', to: 'save_request#receive'
  post '~/:user_token/:campaign/:app/:database', to: 'save_request#receive'
  get '~/:user_token/:campaign/:app/:database', to: 'save_request#receive'

  # Misc
  get 'welcome', to: 'welcome#index', as: 'welcome'
  get 'export', to: 'export#export', as: 'export'
  post 'delete_rows/:campaign_slug/:app_slug/:database_slug', to: 'requests#delete'

  # Campaigns
  get 'new_campaign', to: 'campaigns#new'
  post 'create_campaign', to: 'campaigns#create'
  get 'edit/:campaign_slug/campaign', to: 'campaigns#edit'

  # Apps
  get 'new/:campaign_slug/app', to: 'apps#new'
  post 'create/:campaign_slug/app', to: 'apps#create'
  get 'edit/:campaign_slug/:app_slug', to: 'apps#edit'

  # Databases
  get 'new/:campaign_slug/:app_slug/database', to: 'databases#new'
  post 'create/:campaign_slug/:app_slug/database', to: 'databases#create'
  get 'edit/:campaign_slug/:app_slug/:database_slug', to: 'databases#edit'

  # Zapier Popup
  get 'zapier/:campaign_slug/:app_slug/:database_slug', to: 'databases#zapier'

  # Requets
  get 'new_total/:campaign_slug/:app_slug/:database_slug', to: 'requests#new_total'

  # Campaigns > Apps > Databases > Requests
  resources :campaigns, except: [:show], param: :slug do
    resources :apps, except: [:show], param: :slug, path: '' do
      resources :databases, except: [:show], param: :slug, path: '' do
        resources :requests, only: :index, path: ''
      end
    end
  end

  # Settings
  resources :settings

  # Users
  get 'users', to: 'users#index'
  get 'users/new', to: 'users#new'
  get 'users/edit/:id', to: 'users#edit'

  # Devise
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
