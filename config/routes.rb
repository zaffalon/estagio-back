Rails.application.routes.draw do

  get '', controller: 'welcome', action: 'index', as: 'index'

  get 'start_test', controller: 'welcome', action: 'start_test'

  get 'login', controller: 'user_sessions', action: 'index'

  match '*any' => 'application#route_options', :via => [:options]

  get 'cards/:id/payments/', to: 'cards#payments'

  post 'users/', to: 'users#create'

  resources :cards
  resources :payments
  resources :user_sessions, only: [:index, :create, :destroy]

  root :to => 'welcome#index'

  require 'sidekiq/web'
  # require 'admin_constraint'
  mount Sidekiq::Web => '/sidekiq' #, :constraints => AdminConstraint.new
  Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
    [user, password] == ["zagu", "jwbl12a"]
  end

end
