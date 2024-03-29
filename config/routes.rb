Rails.application.routes.draw do
  devise_for :subscribers, :controllers => { registrations: :registrations }

  root 'welcome#index'

  resources :subscriptions, only: :index do
    get 'edit_all', on: :collection
    put 'update_all', on: :collection
  end
  resources :subscribers, only: :show do
    resources :holidays, only: [:new, :create, :show, :index]
  end

  resource :stripe_sub


  namespace :admin do
    resources :subscribers do
      resources :subscriptions, only: :index do
        collection do
          get :edit_all
          put :update_all
        end
      end
      resources :holidays
      collection { post :import }
    end

    get "/delivery_reports/:date", :to => "delivery_reports#show"
    get "/delivery_reports/", :to => "delivery_reports#show", as: :delivery_reports
    get "/production_reports/:date", :to => "production_reports#show"
    get "/production_reports/", :to => "production_reports#show", as: :production_reports

    resources :wholesale_customers, only: [:new, :create, :edit, :update, :show, :index, :destroy] do
      resources :orders
    end

    resources :email_templates, only: [:index, :edit, :show, :update]
    resources :bread_types, only: [:new, :create, :edit, :update, :show, :index]
    resources :collection_points, only: [:new, :create, :edit, :update, :show, :index]
  end

end
