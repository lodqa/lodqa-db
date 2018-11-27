LodqaDb::Application.routes.draw do
  resources :targets do
    collection do
      get 'names'
    end
    resource :lexical_index_request, only: [:create, :destroy]
  end

  devise_for :users
  get '/users/:username' => 'users#show', :as => 'show_user'
  root :to => 'targets#index'
end
