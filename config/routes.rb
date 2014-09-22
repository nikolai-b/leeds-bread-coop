Rails.application.routes.draw do

  resources :wholesale_customers do
    resources :orders
  end
  post '/orders/copy', to: "orders#copy"
  get '/orders/copy', to: "orders#copy"

  resources :email_templates, only: [:index, :edit, :show, :update]

  resources :bread_types

  resources :collection_points

  devise_for :subscribers, :controllers => { :registrations => "registrations" }
  resources :subscribers do
    resource :subs
    resources :holidays

    collection { post :import }
  end

  root 'welcome#index'
  get "/delivery_reports/:date", :to => "delivery_reports#show", defaults: { date: Date.current.strftime }, as: :delivery_reports
  get "/production_reports/:date", :to => "production_reports#show", defaults: { date: Date.current.strftime }, as: :production_reports

end
