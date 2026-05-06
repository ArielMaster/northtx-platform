Rails.application.routes.draw do
  # Defines the root path route ("/")
  root "pages#home"

  devise_for :users
  post "cookie_consent/accept", to: "cookie_consent#accept"

  get "/e_commerce", to: "blogs#e_commerce"
  get "/essential_tips", to: "blogs#essential_tips"
  get "/importance_ui", to: "blogs#importance_ui"
  get "/analytics", to: "solutions#analytics"
  get "/automation", to: "solutions#automation"
  get "/commerce", to: "solutions#commerce"
  get "/insights", to: "solutions#insights"
  get "/submit_ticket", to: "support#submit_ticket"
  get "/careers", to: "support#careers"
  get "/documentation", to: "support#documentation"
  get "/guides", to: "support#guides"
  get "/cookie_policy", to: "legal#cookie_policy"
  get "/terms", to: "legal#terms"
  get "/privacy", to: "legal#privacy"
  get "/license", to: "legal#license"
  get "/home", to: "pages#home"
  get "/about", to: "pages#about"
  get "/services", to: "pages#services"
  get "/portfolio", to: "pages#portfolio"
  get "/pricing", to: "pages#pricing"
  get "/blog", to: "pages#blog"
  get "/contact", to: "pages#contact"

  resource :checkouts, only: [] do
    get  :info
    post :info_submit

    get  :terms
    post :terms_accept

    get  :review
    post :create_session

    get  :success
  end

  resources :receipts, only: [ :show ]

  post "/stripe/webhook", to: "stripe#webhook"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
