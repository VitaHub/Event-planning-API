Rails.application.routes.draw do
  scope '/api' do
    mount_devise_token_auth_for 'User', at: 'auth', controllers: {
      omniauth_callbacks:  'overrides/omniauth_callbacks'
    }
    resources :events, only: [:index, :show, :create, :update, :destroy] do
      resources :invitations, only: :create
      get "invited" => "invitations#invited_users"
      get "uninvited" => "invitations#uninvited_users"
      resources :comments, only: [:index, :create]
      resources :attachments, only: [:index, :create]
    end
    resources :users, only: :show
    get "feed" => "activities#index"
  end
end
