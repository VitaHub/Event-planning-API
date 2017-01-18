Rails.application.routes.draw do
  scope '/api' do
    resources :events
  end
end
