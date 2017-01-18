Rails.application.routes.draw do
  scope '/api' do
    resources :events, only: [:index, :show, :create, :update, :destroy] do
      resources :invitations, only: :create
    end
  end
end
