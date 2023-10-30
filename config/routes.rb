Rails.application.routes.draw do
  root "dashboards#show"
  resources :filers, only: [:show]
  namespace :api do
    resources :filings, only: [:index, :show]
    resources :filers, only: [:index, :show]
    resources :awards, only: [:index, :show]
  end
end
