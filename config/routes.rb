LodqaDb::Application.routes.draw do
  resources :targets do
    collection do
      get 'names'
    end
  end

  devise_for :users
  get '/users/:username' => 'users#show', :as => 'show_user'
  root :to => 'targets#index'
end
