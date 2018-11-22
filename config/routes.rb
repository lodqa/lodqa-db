LodqaDb::Application.routes.draw do
  resources :targets do
    collection do
      get 'names'
    end
    resources :lexical_index_job, only: :create
  end

  devise_for :users
  get '/users/:username' => 'users#show', :as => 'show_user'
  root :to => 'targets#index'
end
