Rails.application.routes.draw do
  root "dashboards#show"
  resources :filers, only: [:show]
  namespace :api do
    resources :filings, only: [:index]
    resources :filers, only: [:index, :show]
    resources :awards, only: [:index]
    get "awards/historical_snapshot", to: "awards#historical_snapshot"
  end
end
