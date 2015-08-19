Rails.application.routes.draw do
  resources :cats
  resources :cat_rental_requests
  post 'cats/cat_rental_requests/:id/approve',
    to: "cat_rental_requests#approve",
    as: "request_approval"
  post 'cats/cat_rental_requests/:id/deny',
    to: "cat_rental_requests#deny",
    as: 'request_denial'
  resource :user, only: [:create, :new]
  resource :session, only: [:create,:new,:destroy]

  root to: "cat_rental_requests#index"
end
