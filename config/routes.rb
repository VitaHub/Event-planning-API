Rails.application.routes.draw do
  scope '/api' do
    resources :events, only: [:index, :show, :create, :update, :destroy] do
      resources :invitations, only: :create
      get "invited" => "invitations#invited_users"
      get "uninvited" => "invitations#uninvited_users"
    end
  end
end
