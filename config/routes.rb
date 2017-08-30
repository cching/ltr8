Rails.application.routes.draw do
  post '/rate' => 'rater#create', :as => 'rate'
  resources :reviews

  resources :movies do
    collection do
      get :home
      get :home_assets
      get :search
      get 'refresh_now_playing/:index' => :refresh_now_playing, as: 'refresh_now_playing'
      # index of now playing array to load
    end
  end

  root 'movies#home'
end
