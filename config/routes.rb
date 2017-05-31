Rails.application.routes.draw do
	require 'sidekiq/web'
	require 'sidekiq-scheduler/web'
	
	resources :routes

	namespace :admin do
		get 'dashboard/user_search_history'
		get 'dashboard/search_history'
		mount Sidekiq::Web => '/sidekiq'
	end

	get '/about_us', to:'static_pages#about_us'

	get '/flights', to:'search_result#search', as: 'flights'

	get '/flight-prices/:id', to: 'search_result#flight_prices', as: 'flight-prices' #, :defaults => { :format => 'js' }

	get 'home/index'
	get 'static_pages/about_us'
	root 'home#index'

	get '/airport', to:'search_result#airport'
end